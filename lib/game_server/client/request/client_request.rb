require 'game_server/authentication_helper'
require 'game_server/game_server_request'

module GameServer
  module Client
    module Request
      class ClientRequest < GameServer::GameServerRequest

        API_PATH = '/client'

        attr_accessor :api_key, :shared_secret

        def initialize(api_key, shared_secret)
          @api_key = api_key
          @shared_secret = shared_secret
        end

        def get(path, id)
          return super(path, id, headers: client_headers("#{path}/#{id}", {}, 'GET'))
        end

        def post(path, body)
          return super(path, body, headers: client_headers(path, body, 'POST'))
        end

        private def client_headers(path, body, method)
          url = request_url_for_path(path)
          return GameServer::AuthenticationHelper.gs_headers(body.to_json, api_key, shared_secret, url, method)
        end

      end
    end
  end
end