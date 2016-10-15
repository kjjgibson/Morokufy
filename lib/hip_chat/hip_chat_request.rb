require 'request'

module HipChat
  class HipChatRequest < Request

    def send_room_notification(hipchat_url, room_id, room_auth_token, room_notification)
      body_hash = JSON.parse(room_notification.to_json)

      #TODO: check if room_notification is valid first

      post("#{hipchat_url}/v2/room/#{room_id}/notification", body_hash, headers: { 'Authorization': "Bearer #{room_auth_token}" })
    end

  end
end