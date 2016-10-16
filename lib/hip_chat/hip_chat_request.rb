require 'request'

# Class used to send requests to the HipChat API
# Construct this class with the HipChat API URL which will be specific to your organisation

module HipChat
  class HipChatRequest < Request

    # The HipChat API URL
    attr_accessor :url

    def initialize(url: nil)
      @url = url
    end

    # Send a room notification to an existing HipChat room
    #
    # === Parameters
    #
    # * +room+ - A HipChat Room object containing the room id and auth token
    # * +room_notification+ - A RoomNotification object that is to be serialized to JSON and sent in the body of the request
    #
    # @return true if the request was successfully sent
    def send_room_notification(room, room_notification)
      body_hash = JSON.parse(room_notification.to_json)

      if room_notification.valid?
        r = post("#{@url}/v2/room/#{room.room_id}/notification", body_hash, headers: { 'Authorization': "Bearer #{room.room_auth_token}" })
        puts "body: #{r.body}"
        puts "Result: #{r.success?}"

        notification_sent = true
      else
        Rails.logger.error("Could not send HipChat room notification: #{room_notification.errors.full_messages}")
        notification_sent = false
      end

      return notification_sent
    end

  end
end