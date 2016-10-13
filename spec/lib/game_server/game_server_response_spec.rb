require 'rails_helper'
require 'game_server/game_server_response'

describe 'GameServerResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      response = GameServer::GameServerResponse.new(true, 'error')

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
    end
  end

  describe '#is_success?' do
    it 'returns the correct value' do
      response = GameServer::GameServerResponse.new(true, '')

      expect(response.is_success?).to eq(true)
    end
  end

end