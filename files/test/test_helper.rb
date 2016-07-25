ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

# Improved Minitest output (color and progress bar)
require 'minitest/reporters'
Minitest::Reporters.use!(Minitest::Reporters::ProgressReporter.new,
                         ENV,
                         Minitest.backtrace_filter)

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# Capybara and poltergeist integration
require 'capybara/rails'
require 'capybara/poltergeist'

# Capybara.default_driver = :selenium
# Capybara.default_driver = :poltergeist

Capybara.javascript_driver = :poltergeist

module ActionDispatch
  class IntegrationTest
    include Capybara::DSL

    Capybara.server_port = 3001
    Capybara.app_host = 'http://127.0.0.1:3001'

    def assert_content(content)
      assert page.has_content?(content), %q(Expected to found "#{content}" in: "#{page.text}")
    end

    def refute_content(content)
      refute page.has_content?(content), %q(Expected not to found "#{content}" in: "#{page.text}")
    end

    # See: https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
    def wait_for_ajax
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery.active').zero?
    end

    def teardown
      Capybara.use_default_driver
    end
  end
end

# See: https://gist.github.com/mperham/3049152
module ActiveRecord
  class Base
    mattr_accessor :shared_connection
    @shared_connection = nil

    def self.connection
      @shared_connection || ConnectionPool::Wrapper.new(size: 1) { retrieve_connection }
    end
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
