require "minitest_helper"

class V1::UsersControllerTest < MiniTest::Rails::ActionController::TestCase
  test "POST create should return user data if the user is saved" do
    user = Fabricate.build(:user)
    User.expects(:new).returns(user)
    User.any_instance.expects(:save).returns(true)

    post :create, :body => 'Test', :format => :json
    assert_response :success

    result = parse_response_body
    verify_fields_on_json_result(user, result)
  end

  test "POST create should return an error if the user was not saved" do
    User.any_instance.expects(:save).returns(false)
    post :create, :body => 'Test', :format => :json
    assert_response :internal_server_error
  end

  test "GET show should return user information" do
    id = '1234'
    user = Fabricate.build(:user)
    User.expects(:find).with(id).returns(user)

    get :show, :id => id, :format => :json
    assert_response :success

    result = parse_response_body
    verify_fields_on_json_result(user, result)
  end

  def expected_json_object_fields
    %w(username email created_at updated_at)
  end
end
