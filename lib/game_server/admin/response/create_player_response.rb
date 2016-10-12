require 'game_server/game_server_response'

# This class holds the response of a GameServer::Admin::Request::PlayerRequest.create_player request
# Users can access the Game Server API key and shared secret which are then used to authenticate further Client API requests

module GameServer
  module Admin
    module Response
      class CreatePlayerResponse < GameServer::GameServerResponse

        attr_accessor :api_key, :shared_secret

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +api_key+ - The Game Server Player API key
        # * +shared_secret+ - The Game Server Player shared secret
        def initialize(success, error_message, api_key, shared_secret)
          super(success, error_message)
          @api_key = api_key
          @shared_secret = shared_secret
        end

      end
    end
  end
end