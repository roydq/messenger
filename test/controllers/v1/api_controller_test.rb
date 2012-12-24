require 'minitest_helper'
require 'support/testable_api_controller'

class TestableApiControllerTest < MiniTest::Rails::ActionController::TestCase
  before do
    TestableApiController.setup
  end

  after do
    TestableApiController.teardown
  end

  test 'render_model_errors should render error messages' do
    user = Fabricate.build(:user, :username => nil)
    user.valid?
    User.expects(:first).returns(user)

    get :test_render_model_errors
    result = parse_response_body

    assert_response :unprocessable_entity

    assert result["error"] = 'Unable to save object.'
    assert_equal 1, result["details"].length
    assert_equal user.errors.full_messages.first, result["details"].first
  end

  test 'render json should render some json' do
    get :test_render_json
    result = parse_response_body

    assert_response :success
    assert_equal 2, result.length
    assert_equal 'one', result.first
  end

  test 'rescue from document not found should render a 404' do
    get :test_rescue_from_document_not_found, :format => :json
    assert_response :not_found
    parsed = parse_response_body
    assert_equal 'Resource not found.', parsed['error']
  end

  test 'current_user should return the user if logged in' do
    user = Fabricate.build(:user)
    User.expects(:where).with(id: user.id).returns([user])

    get :test_auth_methods, nil, {user_id: user.id}
    assert_equal user, assigns(:user), '@user should have been the logged in user'
  end

  test 'current_user should return nil if logged out' do
    id = '1234'
    User.expects(:where).with(id: id).returns([]).at_least_once

    get :test_auth_methods, nil, {user_id: id}
    assert_nil assigns(:user), '@user should have been nil'
  end

  test 'signed_in? should return true if logged in' do
    user = Fabricate.build(:user)
    User.expects(:where).with(id: user.id).returns([user])

    get :test_auth_methods, nil, {user_id: user.id}
    assert_equal true, assigns(:signed_in), '@signed_in should have been true'
  end

  test 'signed_in? should return false if logged out' do
    id = '1234'
    User.expects(:where).with(id: id).returns([]).at_least_once

    get :test_auth_methods, nil, {user_id: id}
    assert_equal false, assigns(:signed_in), '@signed_in should have been false'
  end

  test 'signed_out? should return false if logged in' do
    user = Fabricate.build(:user)
    User.expects(:where).with(id: user.id).returns([user])

    get :test_auth_methods, {format: :json}, {user_id: user.id}
    assert_equal false, assigns(:signed_out), '@signed_out should have been false'
  end

  test 'signed_out? should return true if logged out' do
    get :test_auth_methods
    assert_equal true, assigns(:signed_out), '@signed_out should have been true'
  end

  test 'require_user should filter and render an error if user is not logged in' do
    get :test_require_user, :format => :json
    assert_response :internal_server_error
    parsed = parse_response_body
    assert_equal 'Please log in.', parsed['error']
  end

  test 'require_user should return true if user is logged in' do
    user = Fabricate.build(:user)
    User.expects(:where).with(id: user.id).returns([user])

    get :test_require_user, {format: :json}, {user_id: user.id}
    assert_response :success
  end

  test 'require_no_user should filter and render an error if user is logged in' do
    user = Fabricate.build(:user)
    User.expects(:where).with(id: user.id).returns([user])

    get :test_require_no_user, {format: :json}, {user_id: user.id}
    assert_response :internal_server_error
    parsed = parse_response_body
    assert_equal 'Please log out.', parsed['error']
  end

  test 'require_no_user should return true if the user is logged out' do
    get :test_require_no_user
    assert_response :success
  end
end
