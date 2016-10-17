require 'hip_chat/hip_chat_request'
require 'hip_chat/room_notification'
require 'hip_chat/card'
require 'hip_chat/icon'
require 'hip_chat/card_attribute'
require 'hip_chat/card_attribute_value'
require 'hip_chat/card_activity'
require 'hip_chat/room'
require 'hip_chat/card_description'

class MorokufyHipChatNotifications

  def send_achievement_awarded_notification(achievement_name, player_name, gs_player)
    #TODO
  end

  # Send a card room notification alerting users of points awarded
  #
  # === Parameters
  #
  # * +points_awarded+ - The number of points that were awarded
  # * +point_type+ - The type of points that were awarded
  # * +player_name+ - The name to display in the message
  # * +gs_player+ - The GameServer Player used to get the number of total points and achievements
  # * +event+ - The event that triggered the points to be awarded - used to construct the reason message
  def send_points_awarded_notification(points_awarded, point_type, player_name, gs_player, event)
    if points_awarded > 0
      verb_string = 'has been awarded'
    else
      verb_string = 'has lost'
    end

    title = "<b>#{player_name}</b> #{verb_string} <b>#{points_awarded}</b> #{point_type}"
    reason = reason_for_event(event)

    room_notification = build_room_notification(title)
    room_notification.card = build_card(title, "#{title} #{reason}", gs_player)

    send_hip_chat_notification(room_notification)
  end

  # Send a HipChat Notification to the room specified in the HipChat config variable
  #
  # === Parameters
  #
  # * +room_notification+ - The notification object to serialize to JSON and send to the HipChat v2 API
  private def send_hip_chat_notification(room_notification)
    room = HipChat::Room.new(room_id: Rails.application.config.hip_chat.room_id,
                             room_auth_token: Rails.application.config.hip_chat.room_auth_token)

    HipChat::HipChatRequest.new(url: Rails.application.config.hip_chat.api_url).send_room_notification(room, room_notification)
  end

  # Build a Room Notification with a message that alerts users
  #
  # === Parameters
  #
  # * +message+ - The message to display on clients that don't support rendering cards
  private def build_room_notification(message)
    room_notification = HipChat::RoomNotification.new(message: message)
    room_notification.color = HipChat::RoomNotification::Color::GRAY
    room_notification.notify = false
    return room_notification
  end

  # Build a card object for a Room Notification
  # The card will be collapsed by default, showing only the 'activity_html'
  # Expanding the card will show a title, description, and the total number of points and achievements the Player has
  #
  # === Parameters
  #
  # * +activity_html+ - The html to display on the collapsed card
  # * +description+ - Description to display when expanding the card
  # * +gs_player+ - The Game Server Player used to get the points and achievements
  private def build_card(activity_html, description, gs_player)
    card = HipChat::Card.new(id: SecureRandom.uuid, style: HipChat::Card::Style::APPLICATION)
    card.format = HipChat::Card::Format::MEDIUM
    card.title = 'Morokufy'
    card.description = HipChat::CardDescription.new(value: description, format: HipChat::CardDescription::ValueFormat::HTML)
    card.icon = HipChat::Icon.new(url: 'http://moroku.com/wp-content/uploads/2015/12/weblogo150-50-copy.png')
    card.activity = HipChat::CardActivity.new(html: activity_html)
    card.attributes = attributes_for_point_types(gs_player).concat([HipChat::CardAttribute.new(label: 'Achievements', value: HipChat::CardAttributeValue.new(label: "#{gs_player.achievement_awards.count}"))])
    return card
  end

  # Builds a CardAttribute for each PlayerPointType that the Game Server Player has
  #
  # === Parameters
  #
  # * +gs_player+ - The Player to get the PointTypes from
  private def attributes_for_point_types(gs_player)
    attributes = []
      gs_player.player_point_types.each do |player_point_type|
        attributes << HipChat::CardAttribute.new(label: player_point_type.point_name, value: HipChat::CardAttributeValue.new(label: "#{player_point_type.count}"))
      end
    return attributes
  end

  # Get a descriptive string for the EventType
  #
  # === Parameters
  #
  # * +event+ - The EventType that caused the Player to be awarded with whatever it was
  private def reason_for_event(event)
    case event
      when GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT
        reason = 'for a failed Semaphore build.'
      when GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT
        reason = 'for a successful Semaphore build.'
      else
        reason = ''
    end

    return reason
  end

end