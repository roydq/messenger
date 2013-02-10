class V1::SessionsController < V1::ApiController
  before_filter :require_user, :only => [:show, :destroy]
  before_filter :require_no_user, :only => [:create]

  def show
    set_session_assigns
  end

  def create
    if user = User.authenticate(params[:login], params[:password])
      set_logged_in_session_vars(user)
      set_session_assigns
      render :action => :show, :location => v1_session_url, :status => :created and return
    end

    respond_to do |f|
      f.json { render :json => {:message => "Login failed."}, :status => :unauthorized }
    end
  end

  def destroy
    clear_logged_in_session_vars
    respond_to do |f|
      f.json { render :json => {:message => "Logout successful."} }
    end
  end

  private
  def clear_logged_in_session_vars
    %w(user_id username email created_at).each do |key|
      session.delete(key)
    end
  end

  def set_session_assigns
    @user_id = session[:user_id]
    @username = session[:username]
    @created_at = session[:created_at]
  end
end
