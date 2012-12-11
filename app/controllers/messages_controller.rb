class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    message = Message.new(params[:message])

    if message.save
      head :created, :location => message
    else
      head :not_acceptable
    end
  end
end
