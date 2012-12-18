ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"

# Uncomment if you want Capybara in accceptance/integration tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
require "minitest/pride"

class MiniTest::Rails::ActiveSupport::TestCase
  def parse_response_body
    Oj.load(response.body)
  end
end

require "mocha/setup"
