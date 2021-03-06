require 'game_server/authentication_helper'
require 'game_server/game_server_request'

# This class is used to send REST requests to the Admin Game Server API.
# All requests will contain the necessary authentication headers required by the Game Server
# Authentication headers are constructed using the API key and shared secret stored in the gameserver config variable

module GameServer
  module Admin
    module Request
      class AdminRequest < GameServer::GameServerRequest

        API_PATH = '/admin'

        # Perform a GET request
        #
        # === Parameters
        #
        # * +path+ - The relative path to perform the request to. E.g. /players
        # * +id+ - The id of the resource to get. E.g 10 or name%20of%20thing - will be suffixed to the end of the URL
        #
        # @return HTTParty response object
        def get(path, id)
          path = "#{API_PATH}#{path}"
          return super(path, id, headers: admin_headers(path, '', 'GET', resource_id: id))
        end

        # Perform a POST request
        #
        # === Parameters
        #
        # * +path+ - The relative path to perform the request to. E.g. /players
        # * +body+ - A hash representing the body of the request - will be converted to JSON
        #
        # @return HTTParty response object
        def post(path, body, headers: {})
          path = "#{API_PATH}#{path}"
          return super(path, body, headers: admin_headers(path, body.to_json, 'POST').merge(headers))
        end

        # Construct the authentication headers required by the Game Server
        #
        # === Parameters
        #
        # * +path+ - The relative path to perform the request to. E.g. /players
        # * +body+ - A hash representing the body of the request - will be converted to JSON
        # * +method+ - The REST method. E.g. POST, GET, etc.
        #
        # @return Hash of headers
        private def admin_headers(path, body, method, resource_id: nil)
          path = request_path(path, resource_id: resource_id)
          return GameServer::AuthenticationHelper.admin_gs_headers(body, path, method)
        end

        protected def request_path(path, resource_id: nil)
          url_string = "/#{Rails.application.config.gameserver.tenant}/#{path}".squeeze('/') # Remove double slashes
          if resource_id
            if resource_id.is_a?(String)
              resource_id = URI.encode(resource_id, /\W/)
            end
            url_string = "#{url_string}/#{resource_id}"
          end

          return URI.parse(url_string)
        end

      end
    end
  end
end