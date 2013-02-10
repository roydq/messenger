module V1
  class MessagesController < V1::ApiController
    before_filter :require_user

    def index
      @messages = Message.all.entries
      respond_with(@messages)
    end

    def show
      @message = Message.find(params[:id])
      respond_with(@message)
    end

    def create
      @message = Message.new(params[:message])
      @message.user = current_user
      @message.username = @message.user.username

      if @message.save
        render :action => :show, :location => v1_message_url(@message.id), :status => :created
      else
        render_model_errors(@message)
      end
    end

    def nearby
    end
  end
end
