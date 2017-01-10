require 'hip_chat/hip_chat_request'
require 'hip_chat/room_notification'
require 'hip_chat/card'
require 'hip_chat/icon'
require 'hip_chat/card_attribute'
require 'hip_chat/card_attribute_value'
require 'hip_chat/card_activity'
require 'hip_chat/card_thumbnail'
require 'hip_chat/room'
require 'hip_chat/card_description'

class MorokufyHipChatNotifications

  def send_achievement_awarded_notification(achievement, player)
    player_alias = get_most_sensible_alias_value(player)
    title = "#{player_alias} unlocked an Achievement!"
    description = "#{player_alias} has been awarded the <b>\"#{achievement.name}\"</b> Achievement.\n#{achievement.description}"

    room_notification = build_room_notification(title)
    room_notification.card = build_achievement_media_card(achievement.image_url, title, description)

    send_hip_chat_notification(room_notification)
  end

  # Send a card room notification alerting users of points awarded
  #
  # === Parameters
  #
  # * +points_awarded+ - An array of PointsAward objects from the ExternalEventResponse
  # * +player+ - Morokufy Player - used to get the name to display in the message
  # * +gs_player+ - The GameServer Player used to get the number of total points and achievements
  # * +event+ - The event that triggered the points to be awarded - used to construct the reason message
  def send_points_awarded_notification(points_awarded, player, gs_player, event)
    title = build_points_awarded_string(player, points_awarded)
    reason = reason_for_event(event)

    room_notification = build_room_notification(title)
    room_notification.card = build_points_activity_card(title, "#{title} #{reason}", gs_player)

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
  private def build_points_activity_card(activity_html, description, gs_player)
    card = HipChat::Card.new(id: SecureRandom.uuid, style: HipChat::Card::Style::APPLICATION)
    card.format = HipChat::Card::Format::MEDIUM
    card.title = 'Morokufy'
    card.description = HipChat::CardDescription.new(value: description, format: HipChat::CardDescription::ValueFormat::HTML)
    card.icon = HipChat::Icon.new(url: 'http://moroku.com/wp-content/uploads/2015/12/weblogo150-50-copy.png')
    card.activity = HipChat::CardActivity.new(html: activity_html)
    card.attributes = attributes_for_point_types(gs_player).concat([HipChat::CardAttribute.new(label: 'Achievements', value: HipChat::CardAttributeValue.new(label: "#{gs_player.achievement_awards.count}"))])
    return card
  end

  private def build_achievement_media_card(image_url, title, description)
    card = HipChat::Card.new(id: SecureRandom.uuid, style: HipChat::Card::Style::MEDIA)
    card.title = title
    card.description = HipChat::CardDescription.new(value: description, format: HipChat::CardDescription::ValueFormat::HTML)
    card.thumbnail = HipChat::CardThumbnail.new(url: image_url)
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
  #TOOD: use localization to remove this entire case statement
  private def reason_for_event(event)
    case event
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT
        reason = 'for a failed Semaphore build.'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT
        reason = 'for a successful Semaphore build.'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_REPOSITORY_PUSH
        reason = 'for a push to a Bitbucket repository'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_CREATED
        reason = 'for creating a Pull Request'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_UPDATED
        reason = 'for updating a Pull Request'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_APPROVED
        reason = 'for approving a Pull Request'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_MERGED
        reason = 'for merging a Pull Request'
      when GameServer::Admin::Request::PlayerExternalEventRequest::EventTypes::BITBUCKET_PULL_REQUEST_COMMENT_CREATED
        reason = 'for commenting on a Pull Request'
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
    alias_type_preferences = [Alias::AliasType::NAME, Alias::AliasType::DISPLAY_NAME, Alias::AliasType::EMAIL, Alias::AliasType::USERNAME]

    alias_type_preferences.each do |alias_type|
      if alias_types.include?(alias_type)
        alias_value = aliases.where(alias_type: alias_type).first.alias_value
        break
      end
    end

    return alias_value
  end

  # Build a string that describes what points have been awarded.
  # E.g. 'Bob has been awarded 10 points, 5 giraffes, and 2 coins'
  #
  # === Parameters
  #
  # * +player+ - Morokufy Player - used to get the name to display in the message
  # * +points_awarded+ - An array of PointsAward objects from the ExternalEventResponse
  private def build_points_awarded_string(player, points_awarded)
    awarded_string = ''

    points_awarded_groups = points_awarded.group_by { |obj| obj.count >= 0 ? :award : :deduct }

    award_points = (points_awarded_groups[:award] || []).map { |obj| "<b>#{obj.count}</b> #{obj.point_type}" }
    deduct_points = (points_awarded_groups[:deduct] || []).map { |obj| "<b>#{-obj.count}</b> #{obj.point_type}" }

    player_alias = get_most_sensible_alias_value(player)
    awarded_string = "<b>#{player_alias}</b> has been awarded #{award_points.to_sentence}" if award_points.count > 0

    if deduct_points.count > 0
      awarded_string = "#{awarded_string}. " if award_points.count > 0
      awarded_string = "#{awarded_string}<b>#{player_alias}</b> has lost #{deduct_points.to_sentence}"
    end

    return awarded_string
  end

end