module V1
  class MessagesController < V1::ApiController
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

      if @message.save
        render :action => :show, :location => v1_message_url(@message.id)
      else
        render_model_errors(@message)
      end
    end
  end
end
