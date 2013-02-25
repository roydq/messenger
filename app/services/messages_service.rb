class MessagesService
  def initialize(messages_data)
    @messages_data = messages_data
  end

  attr_accessor :messages_data

  def get_messages_near_coordinates(latitude, longitude, distance_in_miles=50, page=1)
    distance_in_miles = distance_in_miles || 50 # just in case nil is passed directly
    distance_radians = miles_to_radians(distance_in_miles)
    messages_data.within_circle(coordinates: [[latitude, longitude], distance_radians]).page(page).entries
  end

  def get_message_by_id(id)
    messages_data.find(id)
  end

  def create_message(attributes, user)
    message = messages_data.new(attributes)
    message.user = user
    message.username = user.username
    message.save
    message
  end

  private
  # Converts miles to radians using the earth's equatorial radius
  def miles_to_radians(miles)
    miles/3963.192
  end
end
