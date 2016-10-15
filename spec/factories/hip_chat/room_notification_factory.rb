require 'hip_chat/room_notification'

FactoryGirl.define do
  factory :room_notification, class: HipChat::RoomNotification do
    skip_create

    from 'Morokufy'
    message_format { HipChat::RoomNotification::MessageFormat::HTML }
    color { HipChat::RoomNotification::Color::YELLOW }
    notify false
    message 'message'
    card
  end
end
