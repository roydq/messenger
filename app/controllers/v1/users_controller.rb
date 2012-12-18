class V1::UsersController < V1::ApiController
  def create
    @user = User.new(params[:user])

    if @user.save
      render :show, :location => v1_user_url(@user.id)
    else
      render_model_errors(@user)
    end
  end
end
