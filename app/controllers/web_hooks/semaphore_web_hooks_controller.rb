module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      status = :created
      web_hook = WebHook.find_by_request_url(request.referrer) #TODO: this header is not always set - we'll have to search the body of the request for a particular string (most webhooks should have a url containing the origin site anyways)

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
