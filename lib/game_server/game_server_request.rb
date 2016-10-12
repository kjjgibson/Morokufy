require 'game_server/authentication_helper'

module GameServer
  class GameServerRequest

    def get(path, id, headers: nil)
      request_url = request_url_for_path(path, resource_id: id)
      return HTTParty.get(request_url, headers: headers)
    end

    def post(path, body, headers: nil)
      request_url = request_url_for_path(path)
      return HTTParty.post(request_url, body: body.to_json, headers: headers)
    end

    #TODO: PUT and DELETE

    protected def request_url_for_path(path, resource_id: nil)
      url_string = "#{Rails.application.config.gameserver.url}/#{Rails.application.config.gameserver.tenant}/#{path}".squeeze('/') # Remove double slashes
      url_string = "#{url_string}/#{resource_id}" if resource_id
      return URI.parse("http://#{url_string}")
    end

  end
end