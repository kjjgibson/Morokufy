module GameServer
  class Player

    attr_accessor :nickname, :points, :api_key, :shared_secret

    def initialize(nickname, points, api_key, shared_secret)
      @nickname = nickname
      @points = points
      @api_key = api_key
      @shared_secret = shared_secret
    end

    def self.get(id)

    end

    def self.create(nickname)
      return GameServer::Requests::AdminPlayerRequests.create_player(nickname)
    end

  end
end