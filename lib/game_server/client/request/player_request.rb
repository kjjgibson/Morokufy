require 'game_server/client/request/client_request'
require 'game_server/client/response/get_player_response'
require 'game_server/model/player'
require 'game_server/model/player_point_type'

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
          response = get(RESOURCE_PATH, nickname, headers: { 'API-VERSION': 'V2' })
          response_body = JSON.parse(response.body, symbolize_names: true)

          if response.success?
            #TODO: deserialize response json into Player object automatically
            nickname = response_body[:nickname]
            ext_id = response_body[:ext_id]
            avatar = response_body[:avatar]
            theme = response_body[:theme]
            player_point_types = []
            point_types_response = response_body[:point_types]
            point_types_response.each do |point_type_response|
              player_point_types << GameServer::Model::PlayerPointType.new(point_name: point_type_response[:name], count: point_type_response[:amount])
            end

            player = GameServer::Model::Player.new(nickname, ext_id, avatar, theme)
            player.player_point_types = player_point_types

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