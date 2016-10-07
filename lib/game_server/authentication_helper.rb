module GameServer
  module AuthenticationHelper

    def self.md5_content_hash(request_body)
      return Digest::MD5.base64digest(request_body)
    end

    def self.hmac_hash(key, request_body, request_path, http_method, datetime)
      digest = OpenSSL::Digest.new('sha1')
      return OpenSSL::HMAC.hexdigest(digest, key, hmac_hash_content(request_body, request_path, http_method, datetime))
    end

    def self.hmac_hash_content(request_body, request_path, http_method, datetime)
      path = request_path.respond_to?(:path) ? request_path.path : request_path
      return "#{datetime}\\n#{md5_content_hash(request_body)}\\n#{path}\\n#{http_method}"
    end

    def self.gs_headers(body, gs_api_token, gs_shared_secret, request_path, request_method)
      datetime = Time.now.utc.strftime('%Y%m%d %H:%M:%S %Z')

      return { 'Date': datetime,
               'Content-MD5': md5_content_hash(body),
               'Authorization': "#{gs_api_token} : #{hmac_hash(gs_shared_secret, body, request_path, request_method, datetime)}",
               'Content-Type': 'application/json' }
    end

    def self.admin_gs_headers(body, request_path, request_method)
      admin_api_token = Rails.application.config.gameserver.admin_api_token
      admin_shared_secret = Rails.application.config.gameserver.admin_shared_secret

      return gs_headers(body, admin_api_token, admin_shared_secret, request_path, request_method)
    end

  end
end