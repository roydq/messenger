require "minitest_helper"

class V1::SessionsControllerTest < MiniTest::Rails::ActionController::TestCase
  test 'GET show should return info about the current session' do
    current_user = Fabricate.build(:user)

    time = Time.current
    Time.expects(:current).returns(time)

    login_as(current_user)

    expected_session = get_session_struct(current_user, time)

    get :show, :format => :json
    assert_response :success

    result = parse_response_body
    verify_fields_on_json_result(expected_session, result)
  end

  test 'POST create should login if credentals are valid' do
    password = 'test123'
    login = 'asdf@griggle.com'
    user = Fabricate.build(:user, :email => login, :password => password)
    User.expects(:authenticate).with(login, password).returns(user)

    time = Time.current
    Time.expects(:current).returns(time)

    expected_session = get_session_struct(user, time)

    post :create, :login => login, :password => password, :format => :json
    assert_response :success

    result = parse_response_body
    verify_fields_on_json_result(expected_session, result)

    assert_equal user.id, session[:user_id]
    assert_equal user.email, session[:email]
    assert_equal user.username, session[:username]
    assert_equal time, session[:created_at]
  end

  test 'POST create should not login if credentials are invalid' do
    User.expects(:authenticate).with('asdf', 'asdf').returns(nil)

    post :create, :login => 'asdf', :password => 'asdf', :format => :json
    assert_response :unauthorized
    parsed = parse_response_body
    assert_equal 'Login failed.', parsed['message']
  end

  test 'POST create should fail if the user is already logged in' do
    current_user = Fabricate.build(:user)
    login_as(current_user)

    post :create, :login => 'asdf', :password => 'asdf', :format => :json
    verify_blocked_since_logged_in
  end

  test 'DELETE destroy should logout' do
    current_user = Fabricate.build(:user)
    login_as(current_user)

    post :destroy, :format => :json
    assert_response :success

    assert_nil session[:user_id]
    assert_nil session[:email]
    assert_nil session[:username]
    assert_nil session[:created_at]
  end

  test 'DELETE destroy should fail if the user is already logged out' do
    post :destroy, :format => :json
    verify_blocked_via_auth
  end

  def expected_json_object_fields
    %w(created_at username id)
  end

  # Returns a struct that represents session data.
  # Useful to testing.
  def get_session_struct(user, time)
    expected_session = OpenStruct.new
    expected_session.created_at = time
    expected_session.username = user.username
    expected_session.id = user.id
    expected_session
  end
end
