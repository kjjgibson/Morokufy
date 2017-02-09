require 'game_server/admin/request/player_external_event_request'
require 'game_server/admin/request/achievement_request'
require 'morokufy_hip_chat_notifications'

# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  api_key       :string
#  shared_secret :string
#  identifier    :string
#

# The Morokufy player
#
# This class holds data specific to Morokufy about the Player
# We also store the Player's corresponding Game System credentials so that we can perform requests to the Client API on their behalf
# The Player's identifier is a unique value used to identify this Player on the Game Server
# The identifier can ultimately be anything but we just use the first piece of information that we get about a Player
# This might be the player's name, username, email, etc.
# Because we get different data about a Player from each webhook, the Player's aliases allow us to link this data to a Particular Player
# Once we have the Player, we always use the identifier when talking to the Game System
class Player < ApplicationRecord

  validates_presence_of :identifier

  has_many :aliases
  has_many :rule_consequent_events

  # Log an ExternalEvent on the Game Server (which will run the Rules Engine)
  # If running the Rules Engine resulted in any Points or Achievements being awarded then they will be contained in the response.
  # Create a RuleConsequentEvent to record that something interesting happened
  #
  # === Parameters
  #
  # * +event_name+ - The name of the ExternalEvent to log
  # * +gs_player+ - The Game Server Player object - used to get the total points and Achievements to display in the Hip Chat message
  def log_event(event_name, gs_player)
    Rails.logger.info("Logging event: '#{event_name}'")

    response = GameServer::Admin::Request::PlayerExternalEventRequest.new().log_event(identifier, event_name)

    if response.is_success?
      create_rule_consequent_events(response, event_name)
      send_hip_chat_messages(response, event_name, self, gs_player)
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
          player: self,
          consequent_type: RuleConsequentEvent::ConsequentType::POINTS_CONSEQUENT,
          event_name: event_name,
          point_type: points_award.point_type,
          point_count: points_award.count)
    end

    (external_event_response.achievements_awarded || []).each do |achievement_awarded|
      RuleConsequentEvent.create(
          player: self,
          consequent_type: RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT,
          event_name: event_name,
          achievement_id: achievement_awarded.achievement_id)
    end
  end

  # Send HipChat notifications if points or achievements have been awarded
  #
  # === Parameters
  #
  # * +event_name+ - The event that caused the points and achievements to be awarded
  # * +player+ - The Morokufy Player - used to get the alias when sending the HipChat message
  private def send_hip_chat_messages(external_event_response, event_name, player, gs_player)
    notifications = MorokufyHipChatNotifications.new()
    points_awarded = external_event_response.points_awarded || []
    achievements_awarded = external_event_response.achievements_awarded || []

    # Update the gs player with any points that were just awarded so that we can display the total point types correctly
    points_awarded.each do |points_award|
      update_gs_player_with_points_award(gs_player, points_award)
    end

    # Send a single HipChat notification for all the points that may have been awarded
    notifications.send_points_awarded_notification(points_awarded, player, gs_player, event_name)

    # For each achievement id that we were awarded, get the details of the Achievement and send a HipChat notification
    achievements_awarded.each do |achievement_award|
      achievement_response = GameServer::Admin::Request::AchievementRequest.new().get_achievement(achievement_award.achievement_id)
      notifications.send_achievement_awarded_notification(achievement_response.achievement, player)
    end
  end

  # Update the GS Player's points with the points that have just been awarded by the latest execution of the rules engine
  #
  # === Parameters
  #
  # * +gs_player+ - The Player whose points to update
  # * +points_award+ - The PointsAward object from the ExternalEventResponse
  private def update_gs_player_with_points_award(gs_player, points_award)
    gs_player.player_point_types.each do |player_point_type|
      if player_point_type.point_name == points_award.point_type
        player_point_type.count += points_award.count
      end
    end
  end

end
