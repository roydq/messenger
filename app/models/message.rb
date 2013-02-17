class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :body,        type: String
  field :username,    type: String
  field :coordinates, type: Array
  field :location,    type: String

  index({location: "2d"}, {background: true})

  validates :body, :presence => true
  validates :coordinates, :presence => true
  validates :location, :presence => true
  validates :username, :presence => true

  belongs_to :user, index: true
end
