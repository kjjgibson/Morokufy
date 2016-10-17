require 'game_server/admin/request/external_event_request'
require 'morokufy_hip_chat_notifications'

module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:commit][:author_email]
      name = params[:commit][:author_name]

      player = create_player_if_does_not_exist(name, email)
      if player
        game_server_player = get_game_server_player(player)

        if game_server_player
          if params[:result] == 'passed'
            event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT
          else
            event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT
          end

          log_event(email, event_name, game_server_player)
        else
          Rails.logger.error('Could not get the Game Server Player - not logging the event either')
        end
      else
        Rails.logger.error('Could not create the Player - not logging the event either.')
      end

      render json: :head
    end

  end
end
