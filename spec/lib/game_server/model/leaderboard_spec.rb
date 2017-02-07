require 'game_server/model/leaderboard'
require 'game_server/model/leaderboard_player'

describe 'Leaderboard' do

  describe '#initialize' do
    it 'sets the attributes' do
      leaderboard_player = GameServer::Model::LeaderboardPlayer.new('href', 'href', 100)
      leaderboard = GameServer::Model::Leaderboard.new(1, 'name', 10, 'point_type', 'period', 1, ['tag'], [leaderboard_player])

      expect(leaderboard.id).to eq(1)
      expect(leaderboard.name).to eq('name')
      expect(leaderboard.max_players).to eq(10)
      expect(leaderboard.point_type).to eq('point_type')
      expect(leaderboard.period).to eq('period')
      expect(leaderboard.period_value).to eq(1)
      expect(leaderboard.tags).to eq(['tag'])
      expect(leaderboard.players).to eq([leaderboard_player])
    end
  end

end