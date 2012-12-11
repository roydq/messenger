require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "shit works" do
    user = Fabricate(:user)
    user.username = 'shitter'
    user.save

    assert_equal 'shitter', user.username
  end
end
