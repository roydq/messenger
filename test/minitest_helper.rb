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

  def verify_fields_on_json_result(object, result)
    expected_json_object_fields.each do |field|
      assert_not_nil user.send(field), "#{field} was not rendered in the api output"
      assert_equal user.send(field).as_json, result[field].to_s, "#{field} was unexpected"
    end
  rescue NameError => e
    if e.message.include? 'expected_json_object_fields'
      flunk "Please define an expected_json_object_fields member on your test to use this method"
    end
  end
end

require "mocha/setup"
