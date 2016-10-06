module WebHooks
  class SemaphoreWebHooksController < ApplicationController

    def create
      email = params[:author_email]
      name = params[:author_name]

      if Player.find_by_email(email)
        #TODO: Get player from GS
      else
        Player.create!(name: name, email: email)
        #TODO: Create player on GS
      end

      render json: :head
    end

  end
end
