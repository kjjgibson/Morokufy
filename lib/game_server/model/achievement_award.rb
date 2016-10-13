# Represents an instance of an Achievement being awarded to a Player
# Contains the Achievement ID

module GameServer
  module Model
    class AchievementAward

      attr_accessor :achievement_id

      # === Parameters
      #
      # * +achievement_id+ - The id of the awarded Achievement
      def initialize(achievement_id)
        @achievement_id = achievement_id
      end

    end
  end
end