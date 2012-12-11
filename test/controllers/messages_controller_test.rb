require 'minitest_helper'

class MessagesControllerTest < MiniTest::Rails::ActionController::TestCase
  test "GET index should load all messsages" do
    messages = [Message.new(body: 'crap'), Message.new(body: 'test')]
    Message.expects(:all).returns(messages)

    get :index, :format => :json
    result = parse_response_body

    assert_equal messages.length, result.length

    messages.each_with_index do |message, i|
      assert_equal message.body, result[i]['body']
      assert_equal message.id.to_s, result[i]['id']
    end
  end

  test "GET index should do nothing if there are no messages" do
    Message.expects(:all).returns(nil)

    get :index, :format => :json
    assert_response :success
  end

  test "GET show should return message by id" do
    message = Message.new(body: 'crap')
    Message.expects(:find).with(message.id.to_s).returns(message)

    get :show, :id => message.id.to_s, :format => :json

    result = parse_response_body
    assert_equal message.body, result["body"]
  end

  test "POST create should create a message" do
    Message.any_instance.expects(:save).returns(true)

    post :create, :body => 'Test'

    assert_response :success
 end

  test "POST create should return an error status if the message wasn't saved" do
    Message.any_instance.expects(:save).returns(false)

    post :create, :body => 'Test'

    assert_response :not_acceptable
 end

  private
  def parse_response_body
    Oj.load(response.body)
  end
end
