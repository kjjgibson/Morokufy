require 'rails_helper'
require 'game_server/admin/request/leaderboard_request'

describe 'LeaderboardRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy/admin#{resource_path}" }
  let(:resource_path) { '/leaderboards' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }

  describe '#get_leaderboard' do
    let(:leaderboard_id) { '1' }

    before do
      allow(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with('', URI.parse('/morokufy/admin/leaderboards/1'), 'GET').and_return(mock_headers)
    end

    context 'successful request' do
      let(:response_double) { double('response') }
      let(:response_body) { { id: 1,
                              name: 'name',
                              max_players: 10,
                              point_type: 'point_type',
                              period: 'period',
                              period_value: 1,
                              tags: ['tag'],
                              players: [
                                  { href: 'href', nickname: 'nickname', points: 100 }
                              ] }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(true)

        allow(HTTParty).to receive(:get).and_return(response_double)
      end

      it 'should call the get method on HTTParty' do
        expect(HTTParty).to receive(:get).with(URI.parse('http://gameserver-morokufy.herokuapp.com/morokufy/admin/leaderboards/1'), headers: mock_headers.stringify_keys)

        GameServer::Admin::Request::LeaderboardRequest.new().get_leaderboard(leaderboard_id)
      end

      it 'should return the response object' do
        get_leaderboard_response = GameServer::Admin::Request::LeaderboardRequest.new().get_leaderboard(leaderboard_id)

        expect(get_leaderboard_response.success).to eq(true)
        expect(get_leaderboard_response.error_message).to eq(nil)

        leaderboard = get_leaderboard_response.leaderboard
        expect(leaderboard).not_to eq(nil)
        expect(leaderboard.id).to eq(1)
        expect(leaderboard.name).to eq('name')
        expect(leaderboard.max_players).to eq(10)
        expect(leaderboard.point_type).to eq('point_type')
        expect(leaderboard.period).to eq('period')
        expect(leaderboard.period_value).to eq(1)
        expect(leaderboard.tags).to eq(['tag'])
        expect(leaderboard.players.count).to eq(1)
        player = leaderboard.players.first
        expect(player.href).to eq('href')
        expect(player.nickname).to eq('nickname')
        expect(player.points).to eq(100)
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
        get_leaderboard_response = GameServer::Admin::Request::LeaderboardRequest.new().get_leaderboard(leaderboard_id)

        expect(get_leaderboard_response.success).to eq(false)
        expect(get_leaderboard_response.error_message).to eq('error')
        expect(get_leaderboard_response.leaderboard).to eq(nil)
      end
    end
  end

end