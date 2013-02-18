class MessagesService
  attr_accessor :messages_data

  def initialize(messages_data)
    @messages_data = messages_data
  end

  def get_messages_near_coordinates(latitude, longitude, distance_in_miles=50, page=1)
    distance_radians = miles_to_radians(distance_in_miles)
    messages_data.within_circle([latitude, longitude], distance_radians).page(page)
  end

  def get_message_by_id(id)
    messages_data.find(id)
  end

  private
  # Converts miles to radians using the earth's equatorial radius
  def miles_to_radians(miles)
    miles/3963.192
  end
end
