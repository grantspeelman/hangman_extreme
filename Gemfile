source 'http://rubygems.org'

gem 'rails', '~> 4.1.0'

platforms :ruby do
  gem 'pg'
end
gem 'ohm', '~> 1.3.0'
gem 'ohm-contrib', require: false
gem 'cancan', require: false
gem 'omniauth'
gem 'omniauth-facebook'
gem 'kaminari'
gem 'mxit_api', '>= 0.2.2.pre', require: false
gem 'savon', require: false
gem 'puma', require: false
gem 'whenever', require: false
gem 'grape'
gem 'sidekiq', '~> 2.17', require: false
gem 'sinatra', '>= 1.3.0', require: false # for sidekiq
gem 'slim', require: false # for sidekiq
gem 'hashie'

#gem 'backup', :require => false
#gem 'httparty', :require => false # for backup
#gem 'dropbox-sdk', :require => false  # for backup

# third party
gem 'airbrake', '3.1.16'
gem 'uservoice-ruby', require: false
gem 'gabba', require: false # google analytics

group :production do
  gem 'newrelic_rpm'
  gem 'newrelic-grape'
end

platforms :rbx do
  gem 'racc'
  gem 'rubysl', '~> 2.0'
  gem 'psych'
end

platforms :ruby do
  gem 'libv8', '~> 3.11.8', require: false
  gem 'therubyracer', require: false
end
gem 'wiselinks'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

group :development do
  gem 'capistrano', '~> 2.0', require: false
  gem 'rvm-capistrano', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'spring'
end

group :development, :test do
  gem 'timecop', require: false
  gem 'annotate', require: false
  gem 'rspec-rails', '~> 2.13.0'
  gem 'factory_girl_rails'
end

group :test do
  gem 'test_after_commit'
  gem 'poltergeist', require: false
  gem 'selenium-webdriver', require: false
  gem 'capybara', '~> 2.0.0', require: false
  gem 'database_cleaner'
  gem 'launchy', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'flog', require: false
  gem 'webmock', require: false
  gem 'vcr', require: false
  gem 'coveralls', require: false
end
