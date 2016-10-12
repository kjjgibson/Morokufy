require 'game_server/game_server_response'

# This class holds the response of a GameServer::Admin::Request::PlayerRequest.get_player request
# Users can access the Game Server Player object

module GameServer
  module Client
    module Response
      class GetPlayerResponse < GameServer::GameServerResponse

        attr_accessor :player

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +player+ - The Game Server Player object
        def initialize(success, error_message, player)
          super(success, error_message)
          @player = player
        end

      end
    end
  end
end