require 'morokufy_hip_chat_notifications'
module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_alias = params[:item][:message][:from][:name]
      player = Player.joins(:aliases).where('aliases.alias_value': player_alias).first

      command = params[:item][:message][:message].gsub('/stats ', '')

      response = ""
      if player.present?
        gs_player = get_game_server_player(player)
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

  end
end
