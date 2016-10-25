require 'game_server/admin/request/external_event_request'
require 'morokufy_hip_chat_notifications'

module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:commit][:author_email]
      name = params[:commit][:author_name]

      player = create_or_get_player([Alias.new(alias_value: name, alias_type: Alias::AliasType::NAME), Alias.new(alias_value: email, alias_type: Alias::AliasType::EMAIL)])
      if player
        game_server_player = get_game_server_player(player)

        if game_server_player
          log_event(player, event_name_for_result(params[:result]), game_server_player)
        else
          Rails.logger.error('Could not get the Game Server Player - not logging the event either')
        end
      else
        Rails.logger.error('Could not create or the Player - not logging the event either')
      end

      render json: :head
    end

    # Get the Event name corresponding to the Semaphore result
    #
    # === Parameters
    #
    # * +result+ A string that should either be 'passed' or 'failed'
    private def event_name_for_result(result)
      if result == 'passed'
        event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT
      else
        event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT
      end

      return event_name
    end

  end
end
