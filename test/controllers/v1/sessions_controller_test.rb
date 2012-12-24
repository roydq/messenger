require "minitest_helper"

class V1::SessionsControllerTest < MiniTest::Rails::ActionController::TestCase
  test 'POST create should login if credentals are valid' do
    password = 'test123'
    login = 'asdf@griggle.com'
    user = Fabricate.build(:user, :email => login, :password => password)
    User.expects(:authenticate).with(login, password).returns(user)

    post :create, :login => login, :password => password, :format => :json
    assert_response :success
    parsed = parse_response_body
    assert_equal 'Login successful.', parsed['message']

    assert_equal user.id, session[:user_id]
    assert_equal user.email, session[:email]
    assert_equal user.username, session[:username]
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
  end

  test 'DELETE destroy should fail if the user is already logged out' do
    post :destroy, :format => :json
    verify_blocked_via_auth
  end
end
