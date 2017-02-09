# A representation of the Game Server Leaderboard and all of it's attributes

module GameServer
  module Model
    class Leaderboard

      attr_accessor :id, :name, :max_players, :point_type, :period, :period_value, :tags, :players

      def initialize(id, name, max_players, point_type, period, period_value, tags, players)
        @id = id
        @name = name
        @max_players = max_players
        @point_type = point_type
        @period = period
        @period_value = period_value
        @tags = tags
        @players = players
      end

    end
  end
end