require 'minitest_helper'

class TestableController < V1::ApiController
  def test_render_model_errors
    user = User.first
    render_model_errors(user)
  end

  def test_render_json
    render_json(['one', 'two'], :ok)
  end

  def test_rescue_from_document_not_found
    raise Mongoid::Errors::DocumentNotFound.new(User, {})
  end
end

class TestableControllerTest < MiniTest::Rails::ActionController::TestCase
  before do
    Messenger::Application.routes.draw do
      [ 'test_render_model_errors',
        'test_render_json',
        'test_rescue_from_document_not_found'
      ].each do |method|
        match method => "testable##{method}"
      end
    end
  end

  after do
    Messenger::Application.reload_routes!
  end

  test 'render_model_errors should render error messages' do
    user = Fabricate.build(:user, :username => nil)
    user.valid?
    User.expects(:first).returns(user)

    get :test_render_model_errors
    result = parse_response_body

    assert_response :unprocessable_entity

    assert result["message"] = 'error saving record'
    assert_equal 1, result["errors"].length
    assert_equal user.errors.full_messages.first, result["errors"].first
  end

  test 'render json should render some json' do
    get :test_render_json
    result = parse_response_body

    assert_response :success
    assert_equal 2, result.length
    assert_equal 'one', result.first
  end

  test 'rescue from document not found should render a 404' do
    get :test_rescue_from_document_not_found
    assert_response :not_found
    assert_equal "Resource not found", response.body
  end
end
