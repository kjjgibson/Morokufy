require 'game_server/game_server_response'

# A response from a GameServer::Admin::Request::PlayerExternalEventRequest request
# This class holds any potential points or achievements that may have been awarded due to an Event being logged

module GameServer
  module Admin
    module Response
      class ExternalEventResponse < GameServer::GameServerResponse

        attr_accessor :points_awarded, :achievements_awarded

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +points_awarded+ - An array of PointsAward objects
        # * +achievements_awarded+ - An array of AchievementAward objects
        def initialize(success, error_message, points_awarded, achievements_awarded)
          super(success, error_message)
          @points_awarded = points_awarded
          @achievements_awarded = achievements_awarded
        end

      end
    end
  end
end