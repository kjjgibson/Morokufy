module HipChat
  class Room

    include ActiveModel::Validations
    include ActiveModel::Serialization

    # The HipChat generated ID for the room
    attr_accessor :room_id

    # The auth token used to access the room via the HipChat API
    attr_accessor :room_auth_token

    validates_presence_of :room_id, :room_auth_token

    def initialize(room_id: nil, room_auth_token: nil)
      @room_id = room_id
      @room_auth_token = room_auth_token
    end

  end
end