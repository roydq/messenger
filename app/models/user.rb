class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String

  index({username: 1}, {unique: true, background: true})
  index({email: 1}, {background: true})

  validates_presence_of :password, :on => :create

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_secure_password

  has_many :messages

  def self.authenticate(id, password)
    if user = self.or({username: id}, {email: id}).first
      return user.try(:authenticate, password)
    end
    false
  end

  # Resolves an issue where password was not being automatically
  # copied into the user params hash when posted to via backbone...
  #
  # I guess that for whatever reason, the way has_secure_password works
  # doesn't pull password into attribute_names.
  #
  # wrap_parameters apparently uses this.  We need to use wrap_parameters
  # since backbone posts json to us with no root node.
  def self.attribute_names
    super << 'password'
  end
end
