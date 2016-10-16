require 'game_server/authentication_helper'

# Helper methods used to perform REST requests to the Game Server APIs

module GameServer
  class GameServerRequest

    # Perform a GET request
    #
    # === Parameters
    #
    # * +path+ - The relative path to perform the request to. E.g. /client/players
    # * +id+ - The id of the resource to get. E.g 10 or name%20of%20thing - will be suffixed to the end of the URL
    #
    # @return HTTParty response object
    def get(path, id, headers: nil)
      request_url = request_url_for_path(path, resource_id: id)
      return HTTParty.get(request_url, headers: headers)
    end

    # Perform a POST request
    #
    # === Parameters
    #
    # * +path+ - The relative path to perform the request to. E.g. /admin/players
    # * +body+ - A hash representing the body of the request - will be converted to JSON
    #
    # @return HTTParty response object
    def post(path, body, headers: nil)
      request_url = request_url_for_path(path)

      Rails.logger.info("Url: #{request_url}, body: #{body.to_json}, headers: #{headers}")
      return HTTParty.post(request_url, body: body.to_json, headers: headers.merge({ 'Content-Type': 'application/json' }).stringify_keys)
    end

    #TODO: PUT and DELETE

    # Returns the absolute request URL by concatenating the path with the URL and tenant from the config variables
    protected def request_url_for_path(path, resource_id: nil)
      url_string = "#{Rails.application.config.gameserver.url}/#{Rails.application.config.gameserver.tenant}/#{path}".squeeze('/') # Remove double slashes
      url_string = "#{url_string}/#{resource_id}" if resource_id
      return URI.parse("http://#{url_string}")
    end

  end
end