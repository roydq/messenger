require "minitest_helper"

class UserTest < ActiveSupport::TestCase
  test "fabricator works" do
    user = Fabricate(:user)
    user.save!
  end

  test "user should require password on create" do
    user = Fabricate.build(:user, :password => nil)
    user.valid?
    assert user.errors.full_messages.include? "Password can't be blank"

    user.password = 'test'
    user.save!

    user.password = nil
    user.save!
  end

  test "user should require username" do
    user = Fabricate.build(:user)
    user.username = nil
    user.valid?
    assert user.errors.full_messages.include? "Username can't be blank"
  end

  test "user should require email" do
    user = Fabricate.build(:user)
    user.email = nil
    user.valid?
    assert user.errors.full_messages.include? "Email can't be blank"
  end

  test "user should authenticate with email or username" do
    user = Fabricate(:user, :password => 'testpassword')

    assert User.authenticate(user.username, 'testpassword')
    assert !User.authenticate(user.username, 'bs')

    assert User.authenticate(user.email, 'testpassword')
    assert !User.authenticate(user.email, 'bs')
  end
end
