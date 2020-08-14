# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', require: true
gem 'bcrypt'
gem 'knock'
gem 'pg'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails'

gem 'ffaker'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '<= 3.2.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
