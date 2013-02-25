module V1
  class MessagesController < V1::ApiController
    before_filter :require_user

    def index
      if params[:lat].blank? || params[:lng].blank?
        render_bad_request_error('lat and lng are required parameters') and return
      end

      lat = params[:lat].to_f
      lng = params[:lng].to_f

      @messages = messages_service.get_messages_near_coordinates(lat, lng, params[:distance], params[:page])
      respond_with(@messages)
    end

    def show
      @message = messages_service.get_message_by_id(params[:id])
      respond_with(@message)
    end

    def create
      @message = messages_service.create_message(params[:message], current_user)

      if @message.persisted?
        render :action => :show, :location => v1_message_url(@message.id), :status => :created
      else
        render_model_errors(@message)
      end
    end

    attr_accessor :messages_service
    def messages_service
      @messages_service ||= MessagesService.new(Message)
    end
  end
end
