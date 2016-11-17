require 'game_server/admin/request/player_request'
require 'game_server/model/player'
require 'game_server/client/request/player_request'

# == Schema Information
#
# Table name: web_hooks
#
#  id                :integer          not null, primary key
#  name              :string
#  source_identifier :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class WebHook < ApplicationRecord

  has_many :web_hook_rules, dependent: :destroy
  has_many :web_hook_alias_keys, dependent: :destroy

  validates_presence_of :name, :source_identifier
  validates_uniqueness_of :name, :source_identifier

  def run(params)
    aliases = aliases_for_params(params)

    if aliases.count > 0
      player = create_or_get_player(aliases)

      if player
        game_server_player = get_game_server_player(player)

        if game_server_player
          evaluate_web_hook_rules(params, player, game_server_player)
        else
          Rails.logger.error('Could not get the Game Server Player - not logging the event either')
        end
      else
        Rails.logger.error('Could not create or the Player - not logging the event either')
      end
    else
      Rails.logger.error("No alias keys found in request body. Expected to find: #{web_hook_alias_keys.pluck(:alias_key)}")
    end
  end

  # Build an array of Alias objects by matching the expected WebHookAliasKeys to the params provided
  #
  # === Parameters
  #
  # * +params+ - A hash of params used to search for the expected Alias keys
  def aliases_for_params(params)
    aliases = []

    params.deep_symbolize_keys!

    web_hook_alias_keys.each do |web_hook_alias_key|
      key_paths = web_hook_alias_key.alias_key.split('.')
      alias_value = params
      key_paths.each do |key_path|
        alias_value = alias_value[key_path.to_sym]
        break unless alias_value
      end

      if alias_value
        aliases << Alias.new(alias_value: alias_value, alias_type: web_hook_alias_key.alias_type)
      end
    end

    return aliases
  end

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

  # Evaluate all rules associated with this WebHook
  # For each rule that evaluates to true, log an event using the consequent
  #
  # === Parameters
  #
  # * +params+ - The params over which to evaluate the predicates
  # * +player+ - The Player object used when logging an event
  # * +game_server_player+ - The GameServerPlayer object used when logging an event
  def evaluate_web_hook_rules(params, player, game_server_player)
    web_hook_rules.each do |web_hook_rule|
      if web_hook_rule.evaluate(params)
        web_hook_rule.web_hook_consequents.each do |consequent|
          event_name = consequent.event_name
          player.log_event(event_name, game_server_player)
        end
      end
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

end
