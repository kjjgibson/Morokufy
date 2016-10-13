require 'game_server/admin/request/player_request'

module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:author_email]
      name = params[:author_name]

      unless Player.find_by_email(email)
        response = GameServer::Admin::Request::PlayerRequest.new().create_player(email)
        if response.is_success?
          Player.create!(name: name, email: email, api_key: response.api_key, shared_secret: response.shared_secret)

          #TODO: log event
        else
          Rails.logger.error(response.error_message)
        end
      end

      render json: :head
    end

  end
end
