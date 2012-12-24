module V1
  class ApiController < ApplicationController
    respond_to :json

    helper_method :current_user, :signed_in?, :signed_out?

    # For some reason I was getting errors if I didn't use a proc here...
    rescue_from Mongoid::Errors::DocumentNotFound do |error|
      render_404
    end

    def current_user
      if session[:user_id]
        @current_user ||= User.where(id: session[:user_id]).first
      end
      @current_user
    end

    def signed_in?
      !!current_user
    end

    def signed_out?
      !signed_in?
    end

    private
    def render_model_errors(model)
      content = {:message => 'error saving record', :errors => model.errors.full_messages}
      render_json(content, :unprocessable_entity)
    end

    def render_json(source, status)
      render :json => source, :status => status
    end

    def render_404
      render :json => "Resource not found", :status => :not_found
    end
  end
end
