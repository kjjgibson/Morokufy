module GameServer
  module Model
    class Player

      attr_accessor :nickname, :ext_id, :avatar, :theme

      def initialize(nickname, ext_id, avatar, theme)
        @nickname = nickname
        @ext_id = ext_id
        @avatar = avatar
        @theme = theme
      end

    end
  end
end