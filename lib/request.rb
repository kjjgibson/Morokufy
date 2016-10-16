# Helper methods used to perform REST requests to third part APIs

  class Request

    # Perform a POST request
    #
    # === Parameters
    #
    # * +path+ - The absolute url to perform the request to
    # * +body+ - A hash representing the body of the request - will be converted to JSON
    #
    # @return HTTParty response object
    def post(url, body, headers: nil)
      Rails.logger.info("Url: #{url}, body: #{body.to_json}, headers: #{headers}")
      return HTTParty.post(url, body: body.to_json, headers: headers.merge({ 'Content-Type': 'application/json' }))
    end

  end