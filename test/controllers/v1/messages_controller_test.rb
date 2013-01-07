require 'minitest_helper'

class V1::MessagesControllerTest < MiniTest::Rails::ActionController::TestCase
  test "GET index should load all messsages" do
    messages = [Fabricate.build(:message), Fabricate.build(:message)]
    Message.expects(:all).returns(stub(:entries => messages))

    get :index, :format => :json
    result = parse_response_body

    assert_equal messages.length, result.length

    messages.each_with_index do |message, i|
      verify_message_json(message, result[i])
    end
  end

  test "GET index should do nothing if there are no messages" do
    Message.expects(:all).returns(stub(:entries => nil))

    get :index, :format => :json
    assert_response :success
  end

  test "GET show should return message by id" do
    message = Fabricate.build(:message)
    Message.expects(:find).with(message.id.to_s).returns(message)

    get :show, :id => message.id.to_s, :format => :json
    assert_response :success

    result = parse_response_body
    verify_message_json(message, result)
  end

  test "POST create should return message data if the message is saved" do
    current_user = Fabricate.build(:user)
    login_as(current_user)

    message = Fabricate.build(:message)
    Message.expects(:new).returns(message)
    Message.any_instance.expects(:save).returns(true)

    post :create, :body => 'Test', :format => :json
    assert_response :success

    result = parse_response_body
    verify_message_json(message, result, current_user)
  end

  test "POST create should return an error if the message was not saved" do
    current_user = Fabricate.build(:user)
    login_as(current_user)

    Message.any_instance.expects(:save).returns(false)
    post :create, :body => 'Test', :format => :json
    assert_response :unprocessable_entity
  end

  # Verifies that all of the fields in the result match up, but also
  # verifies some other things.
  def verify_message_json(message, result, current_user=nil)
    %w(lat lng).each do |coord|
      assert_equal Float, result[coord].class, "#{coord} was parsed as a #{coord.class.name}, should have been Float"
    end

    # pass current user if you're testing to verify that fields were
    # pulled in from the logged-in user
    if current_user
      assert_equal current_user.id.to_s, result['user_id']
      assert_equal current_user.username, result['username']
    end

    verify_fields_on_json_result(message, result)
  end

  def expected_json_object_fields
    %w(body lat lng username user_id location)
  end
end
