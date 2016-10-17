# This class holds the points that the Game Server player has been awarded

module GameServer
  module Model
    class PlayerPointType

      attr_accessor :point_name, :count

      def initialize(point_name: nil, count: 0)
        @point_name = point_name
        @count = count
      end

    end
  end
end