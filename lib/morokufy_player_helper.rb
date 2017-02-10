require 'game_server/client/request/player_request'

class MorokufyPlayerHelper

  def get_player (player_alias)

    player = Player.joins(:aliases).where('aliases.alias_value': player_alias).first

    if player.blank?
      Rails.logger.error("Could not find Player on Morokufy")
    end
    return player
  end

  def get_gs_player(morokufy_player)
    gs_player = nil
    gs_response = GameServer::Client::Request::PlayerRequest.new(morokufy_player.api_key, morokufy_player.shared_secret).get_player(morokufy_player.identifier)
    if gs_response.is_success?
      gs_player = gs_response.player
    else
      Rails.logger.error("Could not get the Player on the GameServer: #{gs_response.error_message}")
    end
    return gs_player
  end

end