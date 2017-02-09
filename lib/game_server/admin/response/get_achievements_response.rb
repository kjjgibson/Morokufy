require 'game_server/game_server_response'

# This class holds the response of a GameServer::Admin::Request::AchievementRequest.get_achievements request

module GameServer
  module Admin
    module Response
      class GetAchievementsResponse < GameServer::GameServerResponse

        attr_accessor :achievements

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +achievements+ - The list of Achievement objects returned
        def initialize(success, error_message, achievements)
          super(success, error_message)
          @achievements = achievements
        end

      end
    end
  end
end