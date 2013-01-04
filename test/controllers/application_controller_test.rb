require 'minitest_helper'

class TestableApplicationController < ApplicationController
  def test_something
    @something = something
    render :nothing => true
  end
end

class TestableApplicationControllerTest < MiniTest::Rails::ActionController::TestCase
  before do
    Messenger::Application.routes.draw do
      match 'test_something' => "testable_application#test_something"
    end
  end

  after do
    Messenger::Application.reload_routes!
  end

  test 'something should return derp' do
    get :test_something
    assert_response :success
    assert_equal 'derp', assigns(:something)
  end
end
