require 'game_server/model/player_point_type'

describe 'PlayerPointType' do

  describe '#initialize' do
    it 'sets the attributes' do
      player_point_type = GameServer::Model::PlayerPointType.new(point_name: 'Coins', count: 100)

      expect(player_point_type.point_name).to eq('Coins')
      expect(player_point_type.count).to eq(100)
    end
  end

end