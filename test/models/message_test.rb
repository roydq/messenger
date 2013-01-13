require "minitest_helper"

class MessageTest < MiniTest::Rails::ActiveSupport::TestCase
  test "fabricator works" do
    message = Fabricate(:message)
    message.save!
  end

  test "message should require body" do
    message = Fabricate.build(:message)
    message.body = nil
    assert !message.valid?, 'message should have been invalid without a body'
    assert message.errors.full_messages.include? "Body can't be blank"
  end

  test "message should require coordinates" do
    message = Fabricate.build(:message)
    message.coordinates = nil
    assert !message.valid?, 'message should have been invalid without coordinates'
    assert message.errors.full_messages.include? "Coordinates can't be blank"
  end

  test "message should require location" do
    message = Fabricate.build(:message)
    message.location = nil
    assert !message.valid?, 'message should have been invalid without a location'
    assert message.errors.full_messages.include? "Location can't be blank"
  end
end
