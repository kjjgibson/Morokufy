module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_alias = params[:item][:message][:from][:name]
      player = get_game_server_player(player_alias)

      command = params[:item][:message][:message].gsub('/stats ', '')

      point_type = 'Points'
      if command.present?
        point_type = command
      end

      response = {
          notify: true,
          message_format: 'text',
          from: 'Morokufy'
      }

      if player.present?
        response[:message] = player.player_point_types.find{ |f| f.point_name == point_type}.count
      else
        response[:message] = 'Player could not be found'
      end
      puts response
      render json: response

    end

  end
end
