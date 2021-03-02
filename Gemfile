# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "bootsnap", ">= 1.1.0", require: false
gem "dalli"
gem "faraday"
gem "fuzzy_match"
gem "hashie"
gem "ine-places"
gem "kaminari"
gem "mechanize"
gem "oj"
gem "pg", ">= 0.18", "< 2.0"
gem "pry"
gem "pry-rails"
gem "rails", "~> 6.1"
gem "rollbar"
gem 'redis'
gem 'redis-rails'
gem 'redis-store'
gem "mimemagic"
gem "sidekiq"

group :development, :test do
  gem "pry-remote"
  gem "puma", "~> 3.11"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "memory_profiler"
  gem "rubocop"
end

group :test do
  gem "capybara"
  gem "cuprite"
  gem "launchy"
  gem "minitest"
  gem "mocha"
  gem "selenium-webdriver"
  gem "timecop"
  gem "vcr"
  gem "webmock"
end
