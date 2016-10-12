# A base class for all GameServer responses
# Contains only a success flag and an optional error message
# Specific response classes should inherit this class and add any other specific attributes needed

module GameServer
  class GameServerResponse

    attr_accessor :success, :error_message

    # === Parameters
    #
    # * +success+ - True if the request was successful
    # * +error_message+ - The error message returned by the Game Server if success is false (otherwise nil)
    def initialize(success, error_message)
      @success = success
      @error_message = error_message
    end

    # Returns true if the request was successful
    def is_success?
      return success
    end

  end
end