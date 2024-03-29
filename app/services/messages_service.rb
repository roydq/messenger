class MessagesService
  def initialize(messages_data)
    @messages_data = messages_data
  end

  attr_accessor :messages_data

  def get_messages_near_coordinates(latitude, longitude, distance_in_miles=50, before_date=nil, after_date=nil)
    distance_in_miles = distance_in_miles || 50 # just in case nil is passed directly
    distance_radians = miles_to_radians(distance_in_miles)

    query = messages_data.within_spherical_circle(coordinates: [[latitude, longitude], distance_radians])
      .desc(:created_at).limit(25)

    if before_date
      query = query.where(:created_at.lt => before_date)
    end

    if after_date
      query = query.where(:created_at.gt => after_date)
    end

    query.entries
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
    (miles/3963.192) #*(Math::PI/180.0)
  end
end
