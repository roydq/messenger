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
      respond_to do |f|
        f.json { render :json => {:message => "Please log in."}, :status => :internal_server_error }
      end
      false
    end

    def require_no_user
      return true if signed_out?
      respond_to do |f|
        f.json { render :json => {:message => "Please log out."}, :status => :internal_server_error }
      end
      false
    end

    def render_model_errors(model)
      content = {:message => 'Unable to save object.', :details => model.errors}
      respond_to do |f|
        f.json { render :json => content, :status => :internal_server_error }
      end
    end

    def render_404
      respond_to do |f|
        f.json { render :json => {:message => "Resource not found."}, :status => :not_found }
      end
    end
  end
end
