# A representation of the Game Server Player and all of it's attributes
# This class is constructed by deserializing the response from a Client::Request::PlayerRequest.get_player request

module GameServer
  module Model
    class Player

      attr_accessor :nickname, :ext_id, :avatar, :theme, :player_point_types, :achievement_awards

      def initialize(nickname, ext_id, avatar, theme)
        @nickname = nickname
        @ext_id = ext_id
        @avatar = avatar
        @theme = theme
        @player_point_types = []
        @achievement_awards = []
      end

    end
  end
end