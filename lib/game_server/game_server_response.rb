module GameServer
  class GameServerResponse

    attr_accessor :success, :error_message

    def initialize(success, error_message)
      @success = success
      @error_message = error_message
    end

    def is_success?
      return success
    end

  end
end