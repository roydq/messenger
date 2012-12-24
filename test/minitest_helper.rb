ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"

# Uncomment if you want Capybara in accceptance/integration tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
require "minitest/pride"

class MiniTest::Rails::ActiveSupport::TestCase
  # Only works for ApiController subclasses.
  def login_as(user)
    session[:user_id] = user
    @controller.expects(:current_user).returns(user).at_least(0)
  end

  def parse_response_body
    Oj.load(response.body)
  end

  # For parsing JSON results from an API controller response
  # WARNING: this will convert values to strings, so you must
  #          verify data types on your own.
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

  def verify_blocked_via_auth
    assert_response :internal_server_error
    parsed = parse_response_body
    assert_equal 'Please log in.', parsed['error']
  end

  def verify_blocked_since_logged_in
    assert_response :internal_server_error
    parsed = parse_response_body
    assert_equal 'Please log out.', parsed['error']
  end
end
