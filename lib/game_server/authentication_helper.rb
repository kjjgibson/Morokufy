# Helper class for constructing authentication headers required by the Game Server APIs
# This class relies on two config variables: gameserver.admin_api_token, and gameserver.admin_shared_secret

module GameServer
  module AuthenticationHelper

    # Construct a Hash of authentication headers required by the Client API
    #
    # === Parameters
    #
    # * +body+ - The actual body of the request - used to construct the HMAC signature
    # * +gs_api_token+ - The Game Server Player API key - used to identify the Player on the Game Server
    # * +gs_shared_secret+ - The Game Server Player shared secret - used to encrypt the HMAC
    # * +request_path+ - The absolute path of the request - used to construct the HMAC signature
    # * +request_method+ - The REST method (POST, GET, etc.) - used to construct the HMAC signature
    def self.gs_headers(body, gs_api_token, gs_shared_secret, request_path, request_method)
      datetime = Time.now.utc.strftime('%Y%m%d %H:%M:%S %Z')

      Rails.logger.info("Constructing HMAC with: date = #{datetime}, content MD5 = #{md5_content_hash(body)}, request_path = #{request_path}, request_method = #{request_method}, gs_shared_secret = #{gs_shared_secret}")

      return { 'Date': datetime,
               'Content-MD5': md5_content_hash(body),
               'Authorization': "#{gs_api_token} : #{hmac_hash(gs_shared_secret, body, request_path, request_method, datetime)}",
               'Content-Type': 'application/json' }
    end

    # Construct a Hash of authentication headers required by the Admin API
    # The API key and shared secret are obtained through the config variables: gameserver.admin_api_token, and gameserver.admin_shared_secret
    #
    # === Parameters
    #
    # * +body+ - The actual body of the request - used to construct the HMAC signature
    # * +request_path+ - The absolute path of the request - used to construct the HMAC signature
    # * +request_method+ - The REST method (POST, GET, etc.) - used to construct the HMAC signature
    def self.admin_gs_headers(body, request_path, request_method)
      admin_api_token = Rails.application.config.gameserver.admin_api_token
      admin_shared_secret = Rails.application.config.gameserver.admin_shared_secret

      return gs_headers(body, admin_api_token, admin_shared_secret, request_path, request_method)
    end

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

  end
end