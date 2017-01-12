class WebHooksController < ApplicationController

  def create
    status = :created
    web_hook = WebHook.find_by_source_identifier(params[:source])

    if web_hook
      web_hook.run(params)
    else
      Rails.logger.error("WebHook not supported for url: #{request.referrer}")
      status = :not_found
    end

    render json: :head, status: status
  end

end
