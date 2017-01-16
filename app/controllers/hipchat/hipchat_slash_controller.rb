require 'morokufy_hip_chat_notifications'
module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_alias = params[:item][:message][:from][:name]
      morokufy_player = get_player(player_alias)

      command = params[:item][:message][:message].gsub('/stats ', '')

      response = ""
      if morokufy_player.present?
        gs_player = get_gs_player(morokufy_player)
        response = setup_player_stats_notification(gs_player)

      else
        response = {
            notify: false,
            message_format: 'text',
            from: 'Morokufy',
            message: 'Player could not be found'
        }
      end

      render json: response

    end

    def get_player (player_alias)
      return Player.joins(:aliases).where('aliases.alias_value': player_alias).first
    end

    def get_gs_player(morokufy_player)
      gs_response = GameServer::Client::Request::PlayerRequest.new(morokufy_player.api_key, morokufy_player.shared_secret).get_player(morokufy_player.identifier)
      if gs_response.is_success?
        gs_player = gs_response.player
      else
        Rails.logger.error("Could not get the Player on the GameServer: #{response.error_message}")
      end
      return gs_player
    end

  end
end
