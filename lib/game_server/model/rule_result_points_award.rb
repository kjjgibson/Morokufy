# Represents an instance of Points being awarded to a Player
# Contains the type of Point that was awarded as well as the count

module GameServer
  module Model
    class RuleResultPointsAward

      attr_accessor :point_type, :count

      # === Parameters
      #
      # * +point_type+ - The type of Point awarded
      # * +count+ - The number of point_types awarded
      def initialize(point_type, count)
        @point_type = point_type
        @count = count
      end

    end
  end
end