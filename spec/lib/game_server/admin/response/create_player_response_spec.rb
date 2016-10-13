require 'rails_helper'
require 'game_server/admin/response/create_player_response'

describe 'CreatePlayerResponse' do

  describe '#initialize' do
    it 'sets the attributes' do
      response = GameServer::Admin::Response::CreatePlayerResponse.new(true, 'error', '123', 'abc')

      expect(response.success).to eq(true)
      expect(response.error_message).to eq('error')
      expect(response.api_key).to eq('123')
      expect(response.shared_secret).to eq('abc')
    end
  end

end