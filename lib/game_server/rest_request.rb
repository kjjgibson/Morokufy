module GameServer
  class RestRequest

    def self.get(path, id)

    end

    def self.post(path, body)
      return HTTParty.post(request_url_for_path(path), body: body.to_json, headers: GameServer::AuthenticationHelper.admin_gs_headers(body, request_path, 'POST'))
    end

    def self.put(path, id, body)

    end

    def self.delete(path, id)

    end

    private def request_url_for_path(path)
      return URI.join("http://#{Rails.application.config.gameserver.url}", Rails.application.config.gameserver.tenant, path)
    end

  end
end