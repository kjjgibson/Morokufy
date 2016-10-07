module GameServer
  module Requests
    class AdminPlayerRequests

      PATH = '/admin/players'

      def self.create_player(nickname)
        player = nil

        body = { nickname: nickname, ext_id: nickname }
        response = GameServer::RestRequest.post(PATH, body)

        if response.is_success?
          response_body = JSON.parse(response.body, symbolize_names: true)

          api_key = response_body[:api_token]
          shared_secret = response_body[:shared_secret]

          player = Player.new(nickname, 0, api_key, shared_secret)
        end

        return player
      end

    end
  end
end