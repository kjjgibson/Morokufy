# A representation of the Game Server Player and all of it's attributes
# This class is constructed by deserializing the response from a Client::Request::PlayerRequest.get_player request

module GameServer
  module Model
    class Player

      attr_accessor :nickname, :ext_id, :avatar, :theme, :points, :achievements

      def initialize(nickname, ext_id, avatar, theme)
        @nickname = nickname
        @ext_id = ext_id
        @avatar = avatar
        @theme = theme
        @points = 0
        @achievements = []
      end

    end
  end
end