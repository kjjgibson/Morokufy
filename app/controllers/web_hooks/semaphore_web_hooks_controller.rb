module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:author_email]
      name = params[:author_name]

      if Player.find_by_email(email)
        # @gs_player = GameServer::Player.get(email)
      else
        Player.create!(name: name, email: email)
        # @gs_player = GameServer::Player.create(email)
      end

      #return the points
      render json: :head
    end

  end
end
