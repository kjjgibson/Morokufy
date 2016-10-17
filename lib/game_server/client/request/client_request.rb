require 'game_server/authentication_helper'
require 'game_server/game_server_request'

# This class is used to send REST requests to the Client Game Server API.
# All requests will contain the necessary authentication headers required by the Game Server
# Authentication headers are constructed using the API key and shared secret provided

module GameServer
  module Client
    module Request
      class ClientRequest < GameServer::GameServerRequest

        API_PATH = '/client'

        attr_accessor :api_key, :shared_secret

        # Construct an instance using the credentials provided
        #
        # === Parameters
        #
        # * +api_key+ - The Game Server Player API key used to authenticate the request
        # * +shared_secret+ - The Game Server Player shared secret used to sign the HMAC
        def initialize(api_key, shared_secret)
          @api_key = api_key
          @shared_secret = shared_secret
        end

        # Perform a GET request
        #
        # === Parameters
        #
        # * +path+ - The relative path to perform the request to. E.g. /players
        # * +id+ - The id of the resource to get. E.g 10 or name%20of%20thing - will be suffixed to the end of the URL
        #
        # @return HTTParty response object
        def get(path, id, headers: {})
          path = "#{API_PATH}#{path}"
          return super(path, id, headers: headers.merge(client_headers("#{path}/#{id}", {}, 'GET')))
        end

        # Perform a POST request
        #
        # === Parameters
        #
        # * +path+ - The relative path to perform the request to. E.g. /players
        # * +body+ - A hash representing the body of the request - will be converted to JSON
        #
        # @return HTTParty response object
        def post(path, body)
          path = "#{API_PATH}#{path}"
          return super(path, body, headers: client_headers(path, body, 'POST'))
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
        private def client_headers(path, body, method)
          url = request_url_for_path(path)
          return GameServer::AuthenticationHelper.gs_headers(body.to_json, api_key, shared_secret, url, method)
        end

      end
    end
  end
end