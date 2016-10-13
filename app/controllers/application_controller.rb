class ApplicationController < ActionController::Base

  # If the Player does not exist on Morokufy, first attempt to create them on the Game Server and then if successful, here on Morokufy
  #
  # === Parameters
  #
  # * +name+ - The name used to identify the Player
  # * +email+ - The email used to identify the Player
  #
  # @returns True if the Player was newly created
  def create_player_if_does_not_exist(name, email)
    created_new_player = false

    if Player.find_by_email(email)
      # The Player already exists in Morokufy and therefore should also exist on GameServer so we don't need to do anything
    else
      response = GameServer::Admin::Request::PlayerRequest.new().create_player(email)
      if response.is_success?
        # Only create the Morokufy Player if we successfully created the Player on the Game Server
        Player.create!(name: name, email: email, api_key: response.api_key, shared_secret: response.shared_secret)

        created_new_player = true
      else
        Rails.logger.error("Could not create the Player on the GameServer: #{response.error_message}")
      end
    end

    return created_new_player
  end

  # Log an ExternalEvent on the Game Server (which will run the Rules Engine)
  # If running the Rules Engine resulted in any Points or Achievements being awarded then they will be contained in the response.
  # Create a RuleConsequentEvent to record that something interesting happened
  #
  # === Parameters
  #
  # * +player_ext_id+ - The Player's identifier - used to find the Player on the Game Server
  # * +event_name+ - The name of the ExternalEvent to log
  def log_event(player_ext_id, event_name)
    response = GameServer::Admin::Request::ExternalEventRequest.new().log_event(player_ext_id, event_name)

    if response.is_success?
      create_rule_consequent_events(response, event_name)
    else
      Rails.logger.error("Could not log event on the GameServer: #{response.error_message}")
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

end
