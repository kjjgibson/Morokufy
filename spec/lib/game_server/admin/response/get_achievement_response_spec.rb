require 'rails_helper'
require 'game_server/admin/response/get_achievement_response'

describe 'GetAchievementResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      response = GameServer::Admin::Response::GetAchievementResponse.new(true, 'error', 'name', 'description', 'image_url')

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.name).to eq('name')
      expect(response.description).to eq('description')
      expect(response.image_url).to eq('image_url')
    end
  end

end