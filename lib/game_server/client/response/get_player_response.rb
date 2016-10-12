require 'game_server/game_server_response'

module GameServer
  module Client
    module Response
      class GetPlayerResponse < GameServer::GameServerResponse

        attr_accessor :player

        def initialize(success, error_message, player)
          super(success, error_message)
          @player = player
        end

      end
    end
  end
end