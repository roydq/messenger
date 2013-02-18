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
    @data_stub.expects(:within_circle).with([latitude, longitude], distance_radians).returns(circle_query_stub)
    circle_query_stub.expects(:page).with(2).returns(result_stub)

    @messages_service.get_messages_near_coordinates(latitude, longitude, distance, page)
  end
end
