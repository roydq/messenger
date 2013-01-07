class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :body, type: String
  field :username, type: String
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal
  field :location, type: String

  validates_presence_of :body
  validates_presence_of :lat
  validates_presence_of :lng
  validates_presence_of :location
  validates_presence_of :username

  belongs_to :user
end
