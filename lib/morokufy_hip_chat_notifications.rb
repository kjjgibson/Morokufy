require 'hip_chat/hip_chat_request'
require 'hip_chat/room_notification'
require 'hip_chat/card'
require 'hip_chat/icon'
require 'hip_chat/card_attribute'
require 'hip_chat/card_attribute_value'
require 'hip_chat/card_activity'

class MorokufyHipChatNotifications

  def send_achievement_awarded_notification(achievement_name, player_name, gs_player)
    #TODO
  end

  # Send a card room notification alerting users of points awarded
  #
  # === Parameters
  #
  # * +points_awarded+ - The number of points that were awarded
  # * +player_name+ - The name to display in the message
  # * +gs_player+ - The GameServer Player used to get the number of total points and achievements
  # * +event+ - The event that triggered the points to be awarded - used to construct the reason message
  def send_points_awarded_notification(points_awarded, player_name, gs_player, event)
    title = "<b>#{player_name}</b> has been awarded <b>#{points_awarded}</b> points"
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
            #TODO: get from ENV vars
    HipChat::HipChatRequest.new().send_room_notification('https://moroku.hipchat.com', '3034776', '1MAhSghpwx0A1ag0wlD08lcmKTJhsMbWYI4kRpNU', room_notification)
  end

  # Build a Room Notification with a message that alerts users
  #
  # === Parameters
  #
  # * +message+ - The message to display on clients that don't support rendering cards
  private def build_room_notification(message)
    room_notification = HipChat::RoomNotification.new(message)
    room_notification.color = HipChat::RoomNotification::Color::GRAY
    room_notification.notify = true
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
    card = HipChat::Card.new(SecureRandom.uuid, HipChat::Card::Style::APPLICATION)
    card.format = HipChat::Card::Format::MEDIUM
    card.title = 'Morokufy'
    card.description = description
    card.icon = HipChat::Icon.new('http://moroku.com/wp-content/uploads/2015/12/weblogo150-50-copy.png')
    card.activity = HipChat::CardActivity.new(activity_html)
    card.attributes = [HipChat::CardAttribute.new('Points', HipChat::CardAttributeValue.new(gs_player.points)),
                       HipChat::CardAttribute.new('Achievements', HipChat::CardAttributeValue.new(gs_player.achievements.count))]
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