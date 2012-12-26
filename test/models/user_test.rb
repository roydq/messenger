require "minitest_helper"

class UserTest < ActiveSupport::TestCase
  test "fabricator works" do
    user = Fabricate(:user)
    user.save!
  end

  test "user should require password on create" do
    user = Fabricate.build(:user, :password => nil)
    assert !user.valid?, 'user should have been invalid without password'
    assert user.errors.full_messages.include? "Password can't be blank"

    user.password = 'test'
    user.save!

    user.password = nil
    user.save!
  end

  test "user should require username" do
    user = Fabricate.build(:user)
    user.username = nil
    assert !user.valid?, 'user should have been invalid without username'
    assert user.errors.full_messages.include? "Username can't be blank"
  end

  test "user should require unique username" do
    user = Fabricate(:user)
    poser = Fabricate.build(:user, :username => user.username)
    assert !poser.valid?, 'poser should have been invalid due to duplicate username'
  end

  test "user should require email" do
    user = Fabricate.build(:user)
    user.email = nil
    assert !user.valid?, 'user should have been invalid without email'
    assert user.errors.full_messages.include? "Email can't be blank"
  end

  test "user should require unique email" do
    user = Fabricate(:user)
    poser = Fabricate.build(:user, :email => user.email)
    assert !poser.valid?, 'poser should have been invalid due to duplicate email'
  end

  test "user should authenticate with email or username" do
    user = Fabricate(:user, :password => 'testpassword')

    assert_equal user, User.authenticate(user.username, 'testpassword')
    assert !User.authenticate(user.username, 'bs')

    assert_equal user, User.authenticate(user.email, 'testpassword')
    assert !User.authenticate(user.email, 'bs')
  end

  test "attribute_names should include password" do
    assert User.attribute_names.include? 'password'
  end
end
