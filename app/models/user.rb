class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String

  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_presence_of :email

  has_secure_password

  def self.authenticate(id, password)
    if user = self.or({username: id}, {email: id}).first
      return user.try(:authenticate, password)
    end
    false
  end
end
