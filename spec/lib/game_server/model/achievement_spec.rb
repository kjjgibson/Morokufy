require 'game_server/model/achievement'

describe 'Achievement' do

  describe '#initialize' do
    it 'sets the attributes' do
      player = GameServer::Model::Achievement.new('name', 'description', 'image_url')

      expect(player.name).to eq('name')
      expect(player.description).to eq('description')
      expect(player.image_url).to eq('image_url')
    end
  end

end