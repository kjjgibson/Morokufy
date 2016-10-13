require 'game_server/admin/request/external_event_request'

module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:author_email]
      name = params[:author_name]

      create_player_if_does_not_exist(name, email)

      if params[:result] == 'passed'
        event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT
      else
        event_name = GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT
      end

      log_event(email, event_name)

      render json: :head
    end

  end
end
