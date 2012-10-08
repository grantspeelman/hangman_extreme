source 'https://rubygems.org'

gem 'rails', '~> 3.2.1'

gem 'pg'
gem 'newrelic_rpm'
gem 'thin'
gem 'cancan'
gem 'omniauth'
gem 'kaminari'
gem 'gabba'
gem 'nokogiri'
gem 'json'
gem 'airbrake'
gem 'ledermann-rails-settings', :require => 'rails-settings'
gem 'rest-client', require: 'rest_client'
gem 'ohm'
gem 'ohm-expire', require: 'ohm/expire'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'timecop'
  gem 'annotate'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'heroku'
end

group :test do
  gem 'sqlite3'
  gem 'mysql'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'flog'
  gem "spork-rails"
  gem 'webmock'
  gem "mock_redis"
end
