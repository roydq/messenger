require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "shit works" do
    message = Fabricate(:message)
    message.body = 'shitter'
    message.save

    assert_equal 'shitter', message.body
  end
end
