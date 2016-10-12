require 'game_server/admin/request/player_request'
require 'game_server/admin/request/external_event_request'

module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:author_email]
      name = params[:author_name]

      #TODO: Extract this into another method - all webhooks will need to potentially create a GS player if one doesn't already exist
      unless Player.find_by_email(email)
        response = GameServer::Admin::Request::PlayerRequest.new().create_player(email)
        if response.is_success?
          Player.create!(name: name, email: email, api_key: response.api_key, shared_secret: response.shared_secret)
        else
          Rails.logger.error("Could not create the Player on the GameServer: #{response.error_message}")
        end
      end

      if params[:build_status] #TODO: use the correct key
        event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT
      else
        event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT
      end

      #TODO: extract this into another method - all webhooks will need to create events
      # Log the event
      response = GameServer::Admin::Request::ExternalEventRequest.new().log_event(email, event_name)
      unless response.is_success?
        Rails.logger.error("Could not log event on the GameServer: #{response.error_message}")
      end

      render json: :head
    end

  end
end
