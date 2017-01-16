require 'morokufy_hip_chat_notifications'
module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_alias = params[:item][:message][:from][:name]
      player = Player.joins(:aliases).where('aliases.alias_value': player_alias).first

      command = params[:item][:message][:message].gsub('/stats ', '')

      response = ""
      if player.present?
        gs_response = GameServer::Client::Request::PlayerRequest.new(morokufy_player.api_key, morokufy_player.shared_secret).get_player(morokufy_player.identifier)
        if gs_response.is_success?
          gs_player = gs_response.player
          response = setup_player_stats_notification(gs_player)
        else
          Rails.logger.error("Could not get the Player on the GameServer: #{response.error_message}")
        end

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

  end
end
