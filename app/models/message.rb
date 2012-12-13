class Message
  include Mongoid::Document

  field :body, type: String
  field :author, type: String
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal
end
