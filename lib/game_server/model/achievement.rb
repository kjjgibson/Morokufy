# A representation of the Game Server Achievement and all of it's attributes

module GameServer
  module Model
    class Achievement

      attr_accessor :name, :description, :image_url

      def initialize(name, description, image_url)
        @name = name
        @description = description
        @image_url = image_url
      end

    end
  end
end