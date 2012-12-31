# Inherits from ApiController and provides methods to test
# various private methods on ApiController.
class TestableApiController < V1::ApiController
  before_filter :require_user, :only => :test_require_user
  before_filter :require_no_user, :only => :test_require_no_user

  def test_render_model_errors
    user = User.first
    render_model_errors(user)
  end

  def test_rescue_from_document_not_found
    raise Mongoid::Errors::DocumentNotFound.new(User, {})
  end

  def test_auth_methods
    @user = current_user
    @signed_in = signed_in?
    @signed_out = signed_out?
    render :nothing => true
  end

  def test_require_user
    render :nothing => true
  end

  def test_require_no_user
    render :nothing => true
  end

  class << self
    def setup
      klass = self.to_s.constantize

      Messenger::Application.routes.draw do
        # Automatically define routes to methods that follow this convention:
        # test_<public method name>
        methods = klass.superclass.instance_methods(false).map do |m|
          m.to_s.prepend('test_').gsub(/\?/, '')
        end

        # Add other methods
        methods += [
          'test_rescue_from_document_not_found',
          'test_auth_methods'
        ]

        # Define routes to this controller
        methods.each do |method|
          match method => "testable_api##{method}"
        end
      end
    end

    def teardown
      Messenger::Application.reload_routes!
    end
  end
end
