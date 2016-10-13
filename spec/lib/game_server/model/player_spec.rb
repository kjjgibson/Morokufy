require 'game_server/model/player'

describe 'Player' do

  describe '#initialize' do
    it 'sets the attributes' do
      player = GameServer::Model::Player.new('nickname', 'ext_id', 'avatar', 'theme')

      expect(player.nickname).to eq('nickname')
      expect(player.ext_id).to eq('ext_id')
      expect(player.avatar).to eq('avatar')
      expect(player.theme).to eq('theme')
    end
  end

end