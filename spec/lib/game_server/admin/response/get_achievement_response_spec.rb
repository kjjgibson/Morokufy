require 'rails_helper'
require 'game_server/admin/response/get_achievement_response'
require 'game_server/model/achievement'

describe 'GetAchievementResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      achievement = GameServer::Model::Achievement.new('name', 'description', 'image_url')
      response = GameServer::Admin::Response::GetAchievementResponse.new(true, 'error', achievement)

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.achievement).to eq(achievement)
    end
  end

end