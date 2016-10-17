require 'rails_helper'
require 'game_server/client/request/player_request'

describe 'PlayerRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy/client#{resource_path}/#{nickname}" }
  let(:resource_path) { '/players' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { mock_headers.merge('API-VERSION': 'V2') }
  let(:api_key) { '123' }
  let(:shared_secret) { 'abc' }
  let(:nickname) { 'Bob' }
  let(:request_body) { {}.to_json }

  describe '#get_player' do

    before do
      allow(GameServer::AuthenticationHelper).to receive(:gs_headers).with(request_body, api_key, shared_secret, URI.parse(request_path), 'GET').and_return(mock_headers)
    end

    context 'successful request' do

      let(:response_double) { double('response') }
      let(:response_body) { { nickname: 'nickname', ext_id: 'ext_id', avatar: 'avatar', theme: 'theme', point_types: [{ name: 'Points', amount: 100 }, { name: 'Coins', amount: 10 }] }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(true)

        allow(HTTParty).to receive(:get).and_return(response_double)
      end

      it 'should call the post method on HTTParty' do
        expect(HTTParty).to receive(:get).with(URI.parse(request_path), { headers: expected_headers.deep_stringify_keys })

        GameServer::Client::Request::PlayerRequest.new(api_key, shared_secret).get_player(nickname)
      end

      it 'should return the response object' do
        get_player_response = GameServer::Client::Request::PlayerRequest.new(api_key, shared_secret).get_player(nickname)

        expect(get_player_response.success).to eq(true)
        expect(get_player_response.error_message).to eq(nil)

        player = get_player_response.player
        expect(player).not_to eq(nil)
        expect(player.nickname).to eq('nickname')
        expect(player.ext_id).to eq('ext_id')
        expect(player.avatar).to eq('avatar')
        expect(player.theme).to eq('theme')

        player_point_types = player.player_point_types
        expect(player_point_types.count).to eq(2)
        expect(player_point_types[0].point_name).to eq('Points')
        expect(player_point_types[0].count).to eq(100)
        expect(player_point_types[1].point_name).to eq('Coins')
        expect(player_point_types[1].count).to eq(10)
      end
    end

    context 'failed request' do
      let(:response_double) { double('response') }
      let(:response_body) { { error_message: 'error' }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(false)

        allow(HTTParty).to receive(:get).and_return(response_double)
      end

      it 'should return the response object' do
        get_player_response = GameServer::Client::Request::PlayerRequest.new(api_key, shared_secret).get_player(nickname)

        expect(get_player_response.success).to eq(false)
        expect(get_player_response.error_message).to eq('error')
        expect(get_player_response.player).to eq(nil)
      end
    end
  end

end