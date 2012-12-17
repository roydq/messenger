module V1
  class MessagesController < ApplicationController
    respond_to :json

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
        respond_with(@message, :location => v1_message_url(@message.id))
      else
        head :unprocessable_entity
      end
    end
  end
end
