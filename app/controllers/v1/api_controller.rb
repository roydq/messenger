module V1
  class ApiController < ApplicationController
    respond_to :json

    helper_method :current_user, :signed_in?, :signed_out?

    # For some reason I was getting errors if I didn't use a proc here...
    rescue_from Mongoid::Errors::DocumentNotFound do |error|
      render_404
    end

    protected
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

    def require_user
      return true if signed_in?
      respond_with({:error => "Please log in."}, :status => :internal_server_error, :location => nil)
      return false
    end

    def require_no_user
      return true if signed_out?
      respond_with({:error => "Please log out."}, :status => :internal_server_error, :location => nil)
      false
    end

    def render_model_errors(model)
      content = {:error => 'Unable to save object.', :details => model.errors.full_messages}
      render_json(content, :unprocessable_entity)
    end

    def render_json(source, status)
      render :json => source, :status => status
    end

    def render_404
      respond_with({:error => "Resource not found."}, :status => :not_found, :location => nil)
    end
  end
end
