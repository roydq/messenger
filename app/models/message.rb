class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :body, type: String
  field :author, type: String
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal

  validates_presence_of :body
end
