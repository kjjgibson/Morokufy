require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/get_leaderboard_response'
require 'game_server/model/leaderboard'

# This class is used to perform requests to the Admin Leaderboards Game Server API

module GameServer
  module Admin
    module Request
      class LeaderboardRequest < GameServer::Admin::Request::AdminRequest

        PATH = '/leaderboards'

        # Get a Leaderboard from the Game Server by its ID
        #
        # === Parameters
        # * +id+ - The ID that will be used to identify the Game Server Leaderboard
        #
        # @returns A GetLeaderboardResponse object containing the Game Server response
        def get_leaderboard(id)
          response = get(PATH, id)
          response_body = JSON.parse(response.body, symbolize_names: true)

          error_message = response_body[:error_message]

          if response.success?
            players = []
            response_body[:players].each do |player_hash|
              players << GameServer::Model::LeaderboardPlayer.new(player_hash[:href], player_hash[:nickname], player_hash[:points])
            end

            leaderboard = GameServer::Model::Leaderboard.new(response_body[:id],
                                                             response_body[:name],
                                                             response_body[:max_players],
                                                             response_body[:point_type],
                                                             response_body[:period],
                                                             response_body[:period_value],
                                                             response_body[:tags],
                                                             players)
          else
            leaderboard = nil
          end

          return GameServer::Admin::Response::GetLeaderboardResponse.new(response.success?, error_message, leaderboard)
        end

      end
    end
  end
end