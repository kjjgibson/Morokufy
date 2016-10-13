require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/create_player_response'

# This class is used to perform requests to the Admin Players Game Server API

module GameServer
  module Admin
    module Request
      class PlayerRequest < GameServer::Admin::Request::AdminRequest

        PATH = '/players'

        # Create a Player on the Game Server
        #
        # === Parameters
        # * +nickname+ - The nickname that will be used to identify the Game Server Player
        #
        # @returns A CreatePlayerResponse object containing the Game Server response
        def create_player(nickname)
          body = { nickname: nickname, ext_id: nickname }
          response = post(PATH, body)
          response_body = JSON.parse(response.body, symbolize_names: true)

          if response.is_success?
            api_key = response_body[:api_token]
            shared_secret = response_body[:shared_secret]

            create_player_response = GameServer::Admin::Response::CreatePlayerResponse.new(true, nil, api_key, shared_secret)
          else
            error_message = response_body[:error_message]

            create_player_response = GameServer::Admin::Response::CreatePlayerResponse.new(false, error_message, nil, nil)
          end

          return create_player_response
        end

        #TODO: other admin player requests

      end
    end
  end
end