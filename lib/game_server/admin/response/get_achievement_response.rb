require 'game_server/game_server_response'

# This class holds the response of a GameServer::Admin::Request::AchievementRequest.get_achievement request

module GameServer
  module Admin
    module Response
      class GetAchievementResponse < GameServer::GameServerResponse

        attr_accessor :achievement

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +achievement+ - The Achievement object returned
        def initialize(success, error_message, achievement)
          super(success, error_message)
          @achievement = achievement
        end

      end
    end
  end
end