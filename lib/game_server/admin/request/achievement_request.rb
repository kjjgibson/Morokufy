require 'game_server/admin/request/admin_request'
require 'game_server/admin/response/get_achievement_response'

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

          name = response_body[:name]
          description = response_body[:description]
          image_url = response_body[:image_url]
          error_message = response_body[:error_message]

          return GameServer::Admin::Response::GetAchievementResponse.new(response.success?, error_message, name, description, image_url)
        end

      end
    end
  end
end