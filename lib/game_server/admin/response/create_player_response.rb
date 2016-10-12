require 'game_server/game_server_response'

module GameServer
  module Admin
    module Response
      class CreatePlayerResponse < GameServer::GameServerResponse

        attr_accessor :api_key, :shared_secret

        def initialize(success, error_message, api_key, shared_secret)
          super(success, error_message)
          @api_key = api_key
          @shared_secret = shared_secret
        end

      end
    end
  end
end