require 'game_server/authentication_helper'

module GameServer
  module Requests
    class RestRequest

      def self.get(path, id)
        request_url = request_url_for_path(path, resource_id: id)
        return HTTParty.get(request_url, headers: GameServer::AuthenticationHelper.admin_gs_headers({}.to_json, request_url, 'GET'))
      end

      def self.post(path, body)
        body_json = body.to_json
        request_url = request_url_for_path(path)
        return HTTParty.post(request_url, body: body_json, headers: GameServer::AuthenticationHelper.admin_gs_headers(body_json, request_url, 'POST'))
      end

      def self.request_url_for_path(path, resource_id: nil)
        url_string = "#{Rails.application.config.gameserver.url}/#{Rails.application.config.gameserver.tenant}/#{path}".squeeze('/') # Remove double slashes
        url_string = "#{url_string}/#{resource_id}" if resource_id
        return URI.parse("http://#{url_string}")
      end

    end
  end
end