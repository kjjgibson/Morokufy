class WebHooksController < ApplicationController

  def create
    status = :created
    web_hook = WebHook.find_by_source_identifier(params[:source])

    Rails.logger.info("Webhook received with params: #{params.inspect}")

    if web_hook
      Rails.logger.info("Processing webhook request...")
      web_hook.run(request, params)
    else
      Rails.logger.error("WebHook not supported for url: #{request.referrer}")
      status = :not_found
    end

    render json: :head, status: status
  end

end
