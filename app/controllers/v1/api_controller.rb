module V1
  class ApiController < ApplicationController
    respond_to :json

    private
    def render_model_errors(model)
      content = {:message => 'error saving record', :errors => model.errors.full_messages}
      render_json(content, :unprocessable_entity)
    end

    def render_json(source, status)
      render :json => source, :status => status
    end
  end
end
