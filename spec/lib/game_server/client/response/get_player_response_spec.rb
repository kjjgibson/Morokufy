require 'rails_helper'
require 'game_server/client/response/get_player_response'
require 'game_server/model/player'

describe 'GetPlayerResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      player = GameServer::Model::Player.new(nil, nil, nil, nil)
      response = GameServer::Client::Response::GetPlayerResponse.new(true, 'error', player)

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.player).to eq(player)
    end
  end

end