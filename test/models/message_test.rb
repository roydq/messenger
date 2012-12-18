require "minitest_helper"

class MessageTest < MiniTest::Rails::ActiveSupport::TestCase
  test "shit works" do
    message = Fabricate(:message)
    message.body = 'shitter'
    message.save

    assert_equal 'shitter', message.body
  end

  test "message should require body" do
    message = Fabricate.build(:message)
    message.body = nil
    assert !message.valid?, 'message should have been invalid without a body'
    assert message.errors.full_messages.include? "Body can't be blank"
  end
end
