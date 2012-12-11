require "minitest_helper"

class HomeControllerTest < MiniTest::Rails::ActionController::TestCase
  test "GET index should work" do
    get :index
    assert_response :success
  end
end
