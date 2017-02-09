require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/get_achievement_response'
require 'game_server/admin/response/get_achievements_response'
require 'game_server/model/achievement'

# This class is used to perform requests to the Admin Achievements Game Server API

module GameServer
  module Admin
    module Request
      class AchievementRequest < GameServer::Admin::Request::AdminRequest

        PATH = '/achievements'

        # Get an Achievement from the Game Server by its ID
        #
        # === Parameters
        # * +id+ - The ID that will be used to identify the Game Server Achievement
        #
        # @returns A GetAchievementResponse object containing the Game Server response
        def get_achievement(achievement_id)
          response = get(PATH, achievement_id)
          response_body = JSON.parse(response.body, symbolize_names: true)

          error_message = response_body[:error_message]

          if response.success?
            achievement = GameServer::Model::Achievement.new(response_body[:name], response_body[:description], response_body[:image_url])
          else
            achievement = nil
          end

          return GameServer::Admin::Response::GetAchievementResponse.new(response.success?, error_message, achievement)
        end

        # Get all Achievements from the Game Server
        #
        # @returns A GetAchievementsResponse object containing all the Game Server Achievements
        def get_achievements
          response = get(PATH, nil)
          response_body = JSON.parse(response.body, symbolize_names: true)
          achievements = []
          error_message = nil

          if response.success?
            response_body.each do |achievement_hash|
              achievements << GameServer::Model::Achievement.new(achievement_hash[:name], achievement_hash[:description], achievement_hash[:image_url])
            end
          else
            error_message = response_body[:error_message]
          end

          return GameServer::Admin::Response::GetAchievementsResponse.new(response.success?, error_message, achievements)
        end

      end
    end
  end
end