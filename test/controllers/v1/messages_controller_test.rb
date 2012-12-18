require 'minitest_helper'

class V1::MessagesControllerTest < MiniTest::Rails::ActionController::TestCase
  test "GET index should load all messsages" do
    messages = [Message.new(body: 'crap'), Message.new(body: 'test')]
    Message.expects(:all).returns(stub(:entries => messages))

    get :index, :format => :json
    result = parse_response_body

    assert_equal messages.length, result.length

    messages.each_with_index do |message, i|
      assert_equal message.body, result[i]['body']
      assert_equal message.id.to_s, result[i]['id']
    end
  end

  test "GET index should do nothing if there are no messages" do
    Message.expects(:all).returns(stub(:entries => nil))

    get :index, :format => :json
    assert_response :success
  end

  test "GET show should return message by id" do
    message = Message.new(body: 'crap', lat: 10.0, lng: 15.0, author: 'Roy')
    Message.expects(:find).with(message.id.to_s).returns(message)

    get :show, :id => message.id.to_s, :format => :json

    result = parse_response_body

    %w(body lat lng author).each do |field|
      assert_equal message.send(field).to_s, result[field].to_s
    end
  end

  test "POST create should create a message" do
    Message.any_instance.expects(:save).returns(true)

    post :create, :body => 'Test', :format => :json

    assert_response :success
 end

  test "POST create should return an error if the message was not saved" do
    Message.any_instance.expects(:save).returns(false)
    post :create, :body => 'Test', :format => :json
    assert_response :unprocessable_entity
 end
end
