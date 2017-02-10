require 'rails_helper'
require 'game_server/admin/response/get_achievements_response'
require 'game_server/model/achievement'

describe 'GetAchievementsResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      achievements = [GameServer::Model::Achievement.new('name', 'description', 'image_url')]
      response = GameServer::Admin::Response::GetAchievementsResponse.new(true, 'error', achievements)

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.achievements).to eq(achievements)
    end
  end

end