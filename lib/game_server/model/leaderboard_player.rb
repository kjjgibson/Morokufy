# A representation of the Game Server Player as returned on the Leaderboard and all of it's attributes

module GameServer
  module Model
    class LeaderboardPlayer

      attr_accessor :href, :nickname, :points

      def initialize(href, nickname, points)
        @href = href
        @nickname = nickname
        @points = points
      end

    end
  end
end