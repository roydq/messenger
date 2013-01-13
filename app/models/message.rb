class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :body,        type: String
  field :username,    type: String
  field :coordinates, type: Array
  field :location,    type: String

  validates :body, :presence => true
  validates :coordinates, :presence => true
  validates :location, :presence => true
  validates :username, :presence => true

  belongs_to :user
end
