# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rspec-rails'
end

group :development do
  gem 'bullet'
  gem 'letter_opener'
end

group :test do
end

# core

gem 'rails', '~> 7.0.4', '>= 7.0.4.3'
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'puma'
gem 'redis'
gem 'rack-cors'

# optional

gem 'rails_seeds'
gem 'pg'

# plugins

gem 'core', path: 'packages/core'
gem 'auth', path: 'packages/auth'
