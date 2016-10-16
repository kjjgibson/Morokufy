require 'rails_helper'
require 'game_server/admin/request/player_request'

describe 'PlayerRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy#{resource_path}" }
  let(:resource_path) { '/players' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }

  let(:nickname) { 'Bob' }
  let(:request_body) { { nickname: nickname, ext_id: nickname }.to_json }

  describe '#create_player' do

    before do
      allow(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with(request_body, URI.parse(request_path), 'POST').and_return(mock_headers)
    end

    context 'successful request' do

      let(:response_double) { double('response') }
      let(:response_body) { { api_token: '123', shared_secret: 'abc' }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(true)

        allow(HTTParty).to receive(:post).and_return(response_double)
      end

      it 'should call the post method on HTTParty' do
        expect(HTTParty).to receive(:post).with(URI.parse(request_path), { body: request_body, headers: mock_headers })

        GameServer::Admin::Request::PlayerRequest.new().create_player(nickname)
      end

      it 'should return the response object' do
        create_player_response = GameServer::Admin::Request::PlayerRequest.new().create_player(nickname)

        expect(create_player_response.success).to eq(true)
        expect(create_player_response.error_message).to eq(nil)
        expect(create_player_response.api_key).to eq('123')
        expect(create_player_response.shared_secret).to eq('abc')
      end
    end

    context 'failed request' do
      let(:response_double) { double('response') }
      let(:response_body) { { error_message: 'error' }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(false)

        allow(HTTParty).to receive(:post).and_return(response_double)
      end

      it 'should return the response object' do
        create_player_response = GameServer::Admin::Request::PlayerRequest.new().create_player(nickname)

        expect(create_player_response.success).to eq(false)
        expect(create_player_response.error_message).to eq('error')
        expect(create_player_response.api_key).to eq(nil)
        expect(create_player_response.shared_secret).to eq(nil)
      end
    end
  end

end