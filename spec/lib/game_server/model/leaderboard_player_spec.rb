require 'game_server/model/leaderboard_player'

describe 'LeaderboardPlayer' do

  describe '#initialize' do
    it 'sets the attributes' do
      player = GameServer::Model::LeaderboardPlayer.new('href', 'href', 100)

      expect(player.href).to eq('href')
      expect(player.href).to eq('href')
      expect(player.points).to eq(100)
    end
  end

end