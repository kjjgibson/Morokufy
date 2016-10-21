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
  # * +player+ - Morokufy Player - used to get the name to display in the message
  # * +gs_player+ - The GameServer Player used to get the number of total points and achievements
  # * +event+ - The event that triggered the points to be awarded - used to construct the reason message
  def send_points_awarded_notification(points_awarded, point_type, player, gs_player, event)
    if points_awarded > 0
      verb_string = 'has been awarded'
    else
      verb_string = 'has lost'
    end

    player_alias = get_most_sensible_alias_value(player)
    title = "<b>#{player_alias}</b> #{verb_string} <b>#{points_awarded}</b> #{point_type}"
    reason = reason_for_event(event)

    room_notification = build_room_notification(title)
    room_notification.card = build_card(title, "#{title} #{reason}", gs_player, points_awarded, point_type)

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
  # * +points_awarded+ - The number of points that were awarded
  # * +point_type_awarded+ - The type of points that were awarded
  private def build_card(activity_html, description, gs_player, points_awarded, point_type_awarded)
    card = HipChat::Card.new(id: SecureRandom.uuid, style: HipChat::Card::Style::APPLICATION)
    card.format = HipChat::Card::Format::MEDIUM
    card.title = 'Morokufy'
    card.description = HipChat::CardDescription.new(value: description, format: HipChat::CardDescription::ValueFormat::HTML)
    card.icon = HipChat::Icon.new(url: 'http://moroku.com/wp-content/uploads/2015/12/weblogo150-50-copy.png')
    card.activity = HipChat::CardActivity.new(html: activity_html)
    card.attributes = attributes_for_point_types(gs_player, points_awarded, point_type_awarded).concat([HipChat::CardAttribute.new(label: 'Achievements', value: HipChat::CardAttributeValue.new(label: "#{gs_player.achievement_awards.count}"))])
    return card
  end

  # Builds a CardAttribute for each PlayerPointType that the Game Server Player has
  #
  # === Parameters
  #
  # * +gs_player+ - The Player to get the PointTypes from
  # * +points_awarded+ - The number of points that were awarded
  # * +point_type_awarded+ - The type of points that were awarded
  private def attributes_for_point_types(gs_player, points_awarded, point_type_awarded)
    attributes = []
    gs_player.player_point_types.each do |player_point_type|

      # If we were just awarded some points, update teh GS Player's total count for that point type
      total_point_count = player_point_type.count
      Rails.logger.info("beginning total_point_count: #{total_point_count}")
      Rails.logger.info("player_point_type.point_name: #{player_point_type.point_name}, point_type_awarded: #{point_type_awarded}, points_awarded: #{points_awarded}")
      if player_point_type.point_name == point_type_awarded
        Rails.logger.info("adding newly awarded points")
        total_point_count = total_point_count + points_awarded
      end
      Rails.logger.info("final total_point_count: #{total_point_count}")

      attributes << HipChat::CardAttribute.new(label: player_point_type.point_name, value: HipChat::CardAttributeValue.new(label: "#{total_point_count}"))
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

  # Return the most sensible Alias value that belongs to a Player in order to be used in the Hip Chat message
  # We prefer to use a name, then an email, then a username
  # If the player has no known aliases then we'll default to 'Unknown Player'
  #
  # === Parameters
  # * +player+ - The Player that has many aliases
  #
  # @returns the Alias's alias_value
  private def get_most_sensible_alias_value(player)
    alias_value = 'Unknown Player'

    aliases = player.aliases
    alias_types = aliases.pluck(:alias_type)
    alias_type_preferences = [Alias::AliasType::NAME, Alias::AliasType::EMAIL, Alias::AliasType::USERNAME]

    alias_type_preferences.each do |alias_type|
      if alias_types.include?(alias_type)
        alias_value = aliases.where(alias_type: alias_type).first.alias_value
        break
      end
    end

    return alias_value
  end

end