require 'rails_helper'
require 'game_server/admin/response/get_leaderboard_response'
require 'game_server/model/leaderboard'

describe 'GetLeaderboardResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      leaderboard = GameServer::Model::Leaderboard.new(1, 'name', 10, 'point_type', 'period', 1, ['tag'], [])
      response = GameServer::Admin::Response::GetLeaderboardResponse.new(true, 'error', leaderboard)

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.leaderboard).to eq(leaderboard)
    end
  end

end