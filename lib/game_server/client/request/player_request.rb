require 'game_server/client/request/client_request'
require 'game_server/client/response/get_player_response'
require 'game_server/model/player'

# This class is used to perform requests to the Client Players Game Server API

module GameServer
  module Client
    module Request
      class PlayerRequest < GameServer::Client::Request::ClientRequest

        RESOURCE_PATH = '/players'

        # Get a Player from the Game Server
        #
        # === Parameters
        # * +nickname+ - The nickname of the Game Server Player
        #
        # @returns A GetPlayerResponse object containing the Game Server Player
        def get_player(nickname)
          response = get(RESOURCE_PATH, nickname)
          response_body = JSON.parse(response.body, symbolize_names: true)

          if response.is_success?
            #TODO: deserialize response json into Player object automatically
            nickname = response_body[:nickname]
            ext_id = response_body[:ext_id]
            avatar = response_body[:avatar]
            theme = response_body[:theme]

            player = GameServer::Model::Player.new(nickname, ext_id, avatar, theme)
            get_player_response = GameServer::Client::Response::GetPlayerResponse.new(true, nil, player)
          else
            error_message = response_body[:error_message]

            get_player_response = GameServer::Client::Response::GetPlayerResponse.new(false, error_message, nil)
          end

          return get_player_response
        end

        #TODO: other client player requests

      end
    end
  end
end