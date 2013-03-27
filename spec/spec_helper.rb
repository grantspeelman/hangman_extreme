require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  if ENV['HEADLESS']
    require 'headless'
  end

  if (ENV['COVERAGE'] == 'on')
    require 'simplecov'
    require 'simplecov-rcov'
    class SimpleCov::Formatter::MergedFormatter
      def format(result)
        SimpleCov::Formatter::HTMLFormatter.new.format(result)
        SimpleCov::Formatter::RcovFormatter.new.format(result)
      end
    end
    SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
    SimpleCov.start 'rails' do
      add_filter "/vendor/"
    end
  end

  require "rails/application"
  # Prevent main application to eager_load in the prefork block (do not load files in autoload_paths)
  Spork.trap_method(Rails::Application, :eager_load!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require 'aws-sdk'
  require 'webmock/rspec'
  WebMock.allow_net_connect!
  AWS.config(:dynamo_db_endpoint => 'localhost', :dynamo_db_port => '4567', :use_ssl => false)
  require File.expand_path("../../config/environment", __FILE__)

  # Load all railties files
  Rails.application.railties.all { |r| r.eager_load! }
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'draper/test/rspec_integration'
end

Spork.each_run do
  WebMock.disable_net_connect!
  def in_memory_database?
    Rails.configuration.database_configuration[ENV["RAILS_ENV"]]['database'] == ':memory:'
  end

  if in_memory_database?
    load "#{Rails.root}/db/schema.rb"
    ActiveRecord::Migrator.up('db/migrate') # then run migrations
  end
  FactoryGirl.reload
  DatabaseCleaner.clean_with :truncation

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  VCR.configure do |c|
    c.cassette_library_dir = 'fixtures/vcr_cassettes'
    c.hook_into :webmock
  end

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    config.before(:suite) do
      if ENV["BROWSER"]
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
      (@@headless = Headless.new).start if ENV['HEADLESS']
    end

    config.after(:suite) do
      @@headless.destroy if ENV['HEADLESS']
    end

    config.before(:all, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.after(:all, :js => true) do
      if ENV["BROWSER"]
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
    end

    config.before(:each) do
      DatabaseCleaner.start
      #begin
      #  Dynamoid::Adapter.list_tables.each do |table|
      #    if table =~ /^#{Dynamoid::Config.namespace}/
      #      table = Dynamoid::Adapter.get_table(table)
      #      table.items.each {|i| i.delete}
      #    end
      #  end
      #rescue Exception => e
      #  Rails.logger.warn(e.message)
      #end
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.around(:each, :vcr => :once) do |example|
      VCR.use_cassette(example.metadata[:full_description], :record => :once) do
        example.call
      end
    end

  end

end