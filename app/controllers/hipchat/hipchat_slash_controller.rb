require 'morokufy_hip_chat_notifications'
module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_alias = params[:item][:message][:from][:name]
      player = create_or_get_player([Alias.new(alias_value: player_alias, alias_type: Alias::AliasType::NAME)])

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
