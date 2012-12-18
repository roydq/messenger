require 'minitest_helper'

class V1::MessagesControllerTest < MiniTest::Rails::ActionController::TestCase
  test "GET index should load all messsages" do
    messages = [Fabricate.build(:message), Fabricate.build(:message)]
    Message.expects(:all).returns(stub(:entries => messages))

    get :index, :format => :json
    result = parse_response_body

    assert_equal messages.length, result.length

    messages.each_with_index do |message, i|
      verify_fields_on_json_result(message, result)
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
    verify_fields_on_json_result(message, result)
  end

  test "POST create should return message data if the message is saved" do
    message = Fabricate.build(:message)
    Message.expects(:new).returns(message)
    Message.any_instance.expects(:save).returns(true)

    post :create, :body => 'Test', :format => :json
    assert_response :success

    result = parse_response_body
    verify_fields_on_json_result(message, result)
  end

  test "POST create should return an error if the message was not saved" do
    Message.any_instance.expects(:save).returns(false)
    post :create, :body => 'Test', :format => :json
    assert_response :unprocessable_entity
  end

  def expected_json_object_fields
    %w(body lat lng author)
  end
end
