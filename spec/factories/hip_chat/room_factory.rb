require 'hip_chat/room'

FactoryGirl.define do
  factory :room, class: HipChat::Room do
    skip_create

    room_id 'room_id'
    room_auth_token 'room_auth_token'
  end
end
