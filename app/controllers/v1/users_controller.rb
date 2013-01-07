class V1::UsersController < V1::ApiController
  before_filter :require_no_user, :only => [:create]

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      render :show, :location => v1_user_url(@user.id), :status => :created
    else
      render_model_errors(@user)
    end
  end

  def validate
    user = User.new(params[:user])
    if user.valid?
      head :ok
    else
      render_model_errors(user)
    end
  end
end
