class V1::SessionsController < V1::ApiController
  def create
    if user = User.authenticate(params[:login], params[:password])
      set_logged_in_session_vars(user)
      respond_with("Login successful", :location => v1_user_url(user.id)) and return
    end

    respond_with("Login failed", :location => v1_session_url, :status => :unauthorized)
  end

  def destroy
    clear_logged_in_session_vars
    head :ok
  end

  private
  def set_logged_in_session_vars(user)
    session[:user_id] = user.id
    session[:username] = user.username
    session[:email] = user.email
  end

  def clear_logged_in_session_vars
    %w(user_id username email).each do |key|
      session.delete(key)
    end
  end
end
