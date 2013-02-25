require 'minitest_helper'

class V1::MessagesControllerTest < MiniTest::Rails::ActionController::TestCase
  setup do
    @current_user = Fabricate.build(:user)
    login_as(@current_user)
  end

  test "GET index should require lat and lng params" do
    get :index, :format => :json
    assert_response :bad_request
  end

  test "GET index should load nearby messages if lat and lng are provided" do
    messages = [Fabricate.build(:message), Fabricate.build(:message)]

    # TODO: maybe there's a better way to do this
    @controller.messages_service.expects(:get_messages_near_coordinates).with(10.01, 10.01, nil, nil).returns(messages)

    get :index, :lat => "10.01", :lng => "10.01", :format => :json
    assert_response :success
    result = parse_response_body

    assert_equal messages.length, result.length

    messages.each_with_index do |message, i|
      verify_message_json(message, result[i])
    end
  end

  test "GET show should return message by id" do
    message = Fabricate.build(:message)
    @controller.messages_service.expects(:get_message_by_id).with(message.id.to_s).returns(message)

    get :show, :id => message.id.to_s, :format => :json
    assert_response :success

    result = parse_response_body
    verify_message_json(message, result)
  end

  test "POST create should return message data if the message is saved" do
    message = Fabricate.build(:message, :user => @current_user, :username => @current_user.username)
    params = {:message => {'body' => 'Test'}, :format => :json}

    @controller.messages_service.expects(:create_message).with(params[:message], @current_user).returns(message)
    message.expects(:persisted?).returns(true)

    post :create, params, :format => :json
    assert_response :success

    result = parse_response_body
    verify_message_json(message, result, @current_user)
  end

  test "POST create should return an error if the message was not saved" do
    unsaved_message = stub('unsaved message', {
      :persisted? => false,
      :errors => ['Username is stupid']
    })
    params = {:message => {'invalid' => 'invalid'}, :format => :json}

    @controller.messages_service.expects(:create_message).with(params[:message], @current_user).returns(unsaved_message)

    post :create, params
    assert_response :unprocessable_entity
  end

  # Verifies that all of the fields in the result match up, but also
  # verifies some other things.
  def verify_message_json(message, result, posting_user=nil)
    verify_fields_on_json_result(message, result)

    # pass current user if you're testing to verify that fields were
    # pulled in from the logged-in user
    if posting_user
      assert_equal posting_user.id.to_s, result['user_id']
      assert_equal posting_user.username, result['username']
    end

    result['coordinates'].each do |coord|
      assert_equal Float, coord.class, "#{coord} was parsed as a #{coord.class.name}, should have been Float"
    end
  end

  def expected_json_object_fields
    %w(body location username user_id created_at)
  end
end
