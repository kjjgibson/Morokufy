module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      status = :created
      Rails.logger.info(request.env)
      web_hook = WebHook.find_by_request_url(request.referrer)

      if web_hook
        web_hook.run(params)
      else
        Rails.logger.error("WebHook not supported for url: #{request.referrer}")
        status = :not_found
      end

      render json: :head, status: status
    end

  end
end
