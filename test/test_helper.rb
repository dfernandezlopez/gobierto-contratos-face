# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "mocha/minitest"
require "vcr"
require "webmock/minitest"
require "capybara/rails"
require "capybara/minitest"
require "minitest/mock"
require "sidekiq/testing"

require_relative "./support/fiscal_entity_factory"

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
end

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  Capybara.configure do |config|
    config.default_driver = :cuprite
    config.default_max_wait_time = 10
  end

  self.use_transactional_tests = true

  def setup
    Capybara.current_driver = Capybara.default_driver
  end

  def teardown
    browser = Capybara.current_session.driver.browser
    browser.manage.delete_all_cookies if browser.respond_to?(:manage)
    Capybara.reset_session!
    Timecop.return
  end
end
