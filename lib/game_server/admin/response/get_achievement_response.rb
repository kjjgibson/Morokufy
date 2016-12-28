require 'game_server/game_server_response'

# This class holds the response of a GameServer::Admin::Request::AchievementRequest.get_achievement request

module GameServer
  module Admin
    module Response
      class GetAchievementResponse < GameServer::GameServerResponse

        attr_accessor :name, :description, :image_url

        # === Parameters
        #
        # * +success+ - True if the request was successful
        # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
        # * +name+ - The name of the Achievement
        # * +description+ - The Achievement description - usually what's required to unlock it
        # * +image_url+ - The Achievement image
        def initialize(success, error_message, name, description, image_url)
          super(success, error_message)
          @name = name
          @description = description
          @image_url = image_url
        end

      end
    end
  end
end