require 'rails_helper'
require 'game_server/admin/response/external_event_response'

describe 'ExternalEventResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      points_awarded_double = double('points_awarded')
      achievement_awarded_double = double('achievement_awarded')
      response = GameServer::Admin::Response::ExternalEventResponse.new(true, 'error', points_awarded_double, achievement_awarded_double)

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.points_awarded).to eq(points_awarded_double)
      expect(response.achievements_awarded).to eq(achievement_awarded_double)
    end
  end

end