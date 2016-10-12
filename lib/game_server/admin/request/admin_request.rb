require 'game_server/authentication_helper'
require 'game_server/game_server_request'

module GameServer
  module Admin
    module Request
      class AdminRequest < GameServer::GameServerRequest

        API_PATH = '/admin'

        def get(path, id)
          return super(path, id, headers: admin_headers(path, {}, 'GET'))
        end

        def post(path, body)
          return super(path, body, headers: admin_headers(path, body, 'POST'))
        end

        private def admin_headers(path, body, method)
          return GameServer::AuthenticationHelper.admin_gs_headers(body.to_json, request_url_for_path(path), method)
        end

      end
    end
  end
end