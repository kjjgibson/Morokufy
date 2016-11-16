module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      status = :created
      web_hook = WebHook.find_by_request_url(request.original_url)

      if web_hook
        web_hook.run(params)
      else
        Rails.logger.error("WebHook not supported for url: #{request.original_url}")
        status = :not_found
      end

      render json: :head, status: status
    end

  end
end
