module GameServer
  class Player

    attr_accessor :nickname, :points

    def self.get(id)
      # response = RestRequest.get('/admin/players', id)
      # player = nil #TODO: parse response to get player
      # return player
    end

    def self.create(nickname)

    end

  end
end