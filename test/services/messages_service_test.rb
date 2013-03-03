require "minitest_helper"

class MessagesServiceTest < MiniTest::Rails::ActiveSupport::TestCase
  before do
    @data_stub = stub(:messages_data)
    @messages_service = MessagesService.new(@data_stub)
  end

  test 'get_messages_near_coordinates should perform a location-based query' do
    latitude = 10
    longitude = 10
    distance = 5
    distance_radians = distance/3963.192
    page = 2

    circle_query_stub = stub(:query)
    result_stub = stub(:result)
    @data_stub.expects(:within_spherical_circle).with(coordinates: [[latitude, longitude], distance_radians]).returns(circle_query_stub)
    circle_query_stub.expects(:desc).with(:created_at).returns(circle_query_stub)
    circle_query_stub.expects(:limit).with(25).returns(result_stub)
    result_stub.expects(:entries)

    @messages_service.get_messages_near_coordinates(latitude, longitude, distance)
  end

  test 'get_messages_near_coordinates should work even if distance is nil' do
    latitude = 10
    longitude = 10
    distance_radians = 50/3963.192

    circle_query_stub = stub(:query)
    result_stub = stub(:result)
    @data_stub.expects(:within_spherical_circle).with(coordinates: [[latitude, longitude], distance_radians]).returns(circle_query_stub)
    circle_query_stub.expects(:desc).with(:created_at).returns(circle_query_stub)
    circle_query_stub.expects(:limit).with(25).returns(result_stub)
    result_stub.expects(:entries)

    @messages_service.get_messages_near_coordinates(latitude, longitude)
  end

  test 'get_messages_near_coordinates should query for messages before a given date' do
    latitude = 10
    longitude = 10
    distance_radians = 50/3963.192
    circle_query_stub = stub(:query)
    time = Time.now
    result_stub = stub(:result)
    @data_stub.expects(:within_spherical_circle).with(coordinates: [[latitude, longitude], distance_radians]).returns(circle_query_stub)
    circle_query_stub.expects(:desc).with(:created_at).returns(circle_query_stub)
    circle_query_stub.expects(:limit).with(25).returns(circle_query_stub)
    circle_query_stub.expects(:created_at.lt).with(time).returns(result_stub)

    @messages_service.get_messages_near_coordinates(latitude, longitude, time)
  end

  test "get_message_by_id should try to find message by id" do
    @data_stub.expects(:find).with(1)
    @messages_service.get_message_by_id(1)
  end

  test "create_message should try to save a message and return the message" do
    message = Message.new
    user = User.new(:username => 'test')
    message.expects(:user=).with(user)
    message.expects(:username=).with(user.username)
    message.expects(:save).returns(true)
    @data_stub.expects(:new).returns(message)

    @messages_service.create_message({:body => 'derp'}, user)
  end
end
