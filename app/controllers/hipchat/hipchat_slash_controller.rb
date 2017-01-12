module Hipchat
  class HipchatSlashController < ApplicationController

    def create
      player_alias = params[:item][:message][:from][:name]
      player = create_or_get_player([Alias.new(alias_value: player_alias, alias_type: Alias::AliasType::NAME)])

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
