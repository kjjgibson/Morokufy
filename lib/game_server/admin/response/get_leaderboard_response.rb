require 'game_server/game_server_response'

# This class holds the response of a GameServer::Admin::Request::LeaderboardRequest.get_leaderboard request

module GameServer
  module Admin
    module Response
      class GetLeaderboardResponse < GameServer::GameServerResponse

        attr_accessor :leaderboard

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +leaderboard+ - The Leaderboard object returned
        def initialize(success, error_message, leaderboard)
          super(success, error_message)
          @leaderboard = leaderboard
        end

      end
    end
  end
end