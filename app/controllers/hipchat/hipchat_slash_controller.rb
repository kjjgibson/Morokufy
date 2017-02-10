require 'morokufy_hip_chat_notifications'
require 'morokufy_player_helper'
module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_helper = MorokufyPlayerHelper.new()

      player_alias = params[:item][:message][:from][:name]
      morokufy_player = player_helper.get_player(player_alias)

      response = ''
      if morokufy_player.present?
        gs_player = player_helper.get_gs_player(morokufy_player)
        notifications = MorokufyHipChatNotifications.new()
        response = notifications.setup_player_stats_notification(gs_player)
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
