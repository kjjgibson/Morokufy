require 'game_server/admin/request/player_request'
require 'game_server/admin/request/external_event_request'
require 'morokufy_hip_chat_notifications'
require 'game_server/model/player'
require 'game_server/client/request/player_request'

class ApplicationController < ActionController::Base

  # If the Player does not exist on Morokufy, first attempt to create them on the Game Server and then if successful, here on Morokufy
  #
  # === Parameters
  #
  # * +aliases+ - An array of Alias objects - used to find the Player
  #
  # @returns The Morokufy Player
  def create_or_get_player(aliases)
    player = Player.joins(:aliases).where('aliases.alias_value': aliases.pluck(:alias_value)).first

    if player
      # The Player already exists in Morokufy and therefore should also exist on GameServer so we don't need to do much
      # We should just update the Player's aliases just in case we've received some new aliases
      add_new_player_aliases(player, aliases)
      player.save!
    else
      # Use the first alias we get as the Game Server identifier
      identifier = aliases[0][:alias_value].downcase.gsub(/\s+/, '')
      response = GameServer::Admin::Request::PlayerRequest.new().create_player(identifier)
      if response.is_success?
        # Only create the Morokufy Player if we successfully created the Player on the Game Server
        player = Player.new(identifier: identifier, api_key: response.api_key, shared_secret: response.shared_secret)
        player.save!
        add_new_player_aliases(player, aliases)
      else
        Rails.logger.error("Could not create the Player on the GameServer: #{response.error_message}")
      end
    end

    return player
  end

  # Get the Game Server Player from the Game Server
  #
  # === Parameters
  #
  # * +morokufy_player+ - The Player used to get the GS api key and shared secret to perform the GS request
  def get_game_server_player(morokufy_player)
    player = nil

    response = GameServer::Client::Request::PlayerRequest.new(morokufy_player.api_key, morokufy_player.shared_secret).get_player(morokufy_player.identifier)
    if response.is_success?
      player = response.player
    else
      Rails.logger.error("Could not get the Player on the GameServer: #{response.error_message}")
    end

    return player
  end

  # Log an ExternalEvent on the Game Server (which will run the Rules Engine)
  # If running the Rules Engine resulted in any Points or Achievements being awarded then they will be contained in the response.
  # Create a RuleConsequentEvent to record that something interesting happened
  #
  # === Parameters
  #
  # * +player+ - The Player - used to find the Player on the Game Server
  # * +event_name+ - The name of the ExternalEvent to log
  # * +gs_player+ - The Game Server Player object - used to get the total points and Achievements to display in the Hip Chat message
  def log_event(player, event_name, gs_player)
    response = GameServer::Admin::Request::ExternalEventRequest.new().log_event(player.identifier, event_name)

    if response.is_success?
      create_rule_consequent_events(response, event_name)
      send_hip_chat_messages(response, event_name, player, gs_player)
    else
      Rails.logger.error("Could not log event on the GameServer: #{response.error_message}")
    end
  end

  # Add new aliases to a Player
  # If the Player already has an alias with that exact value then don't add it
  #
  # === Parameters
  #
  # * +player+ - The Player to add the Aliases to
  # * +new_aliases+ - An array of Alias hashes
  private def add_new_player_aliases(player, new_aliases)
    current_alias_values = player.aliases.pluck(:alias_value)
    new_aliases = new_aliases.reject { |new_aliaz| current_alias_values.include?(new_aliaz.alias_value) }

    new_aliases.each do |aliaz|
      aliaz.player = player
      aliaz.save!
    end
  end

  # Create a RuleConsequent for every point type and achievement that may have been awarded
  # As a consequent of logging the ExternalEvent
  #
  # === Parameters
  #
  # * +external_event_response+ - An ExternalEventResponse class containing possible points and achievements awarded
  # * +event_name+ - The event that caused the points and achievements to be awarded
  private def create_rule_consequent_events(external_event_response, event_name)
    (external_event_response.points_awarded || []).each do |points_award|
      RuleConsequentEvent.create(
          consequent_type: RuleConsequentEvent::ConsequentType::POINTS_CONSEQUENT,
          event_name: event_name,
          point_type: points_award.point_type,
          point_count: points_award.count)
    end

    (external_event_response.achievements_awarded || []).each do |achievement_awarded|
      RuleConsequentEvent.create(
          consequent_type: RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT,
          event_name: event_name,
          achievement_id: achievement_awarded.achievement_id)
    end
  end

  # Send HipChat notifications if points have been awarded
  #
  # === Parameters
  #
  # * +event_name+ - The event that caused the points and achievements to be awarded
  # * +player+ - The Morokufy Player - used to get the alias when sending the HipChat message
  private def send_hip_chat_messages(external_event_response, event_name, player, gs_player)
    notifications = MorokufyHipChatNotifications.new()

    (external_event_response.points_awarded || []).each do |points_award|
      notifications.send_points_awarded_notification(points_award.count, points_award.point_type, player, gs_player, event_name)
    end
  end

end
