module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      Rails.logger.info("Received Semaphore request with params: #{params.inspect}")

      render json: :head
    end

  end
end
