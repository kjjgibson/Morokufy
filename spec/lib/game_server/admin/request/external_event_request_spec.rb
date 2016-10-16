require 'rails_helper'
require 'game_server/admin/request/external_event_request'

describe 'ExternalEventRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy/admin#{resource_path}" }
  let(:resource_path) { '/external_events/log_event' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { mock_headers.merge({'API-VERSION': 'v2', 'Content-Type': 'application/json'})}
  let(:player_ext_id) { 123 }
  let(:external_event_id) { 456 }
  let(:request_body) { { player: player_ext_id, external_event_id: external_event_id }.to_json }

  describe '#log_event' do
    before do
      allow(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with(request_body, URI.parse(request_path), 'POST').and_return(mock_headers)
    end

    context 'successful request' do

      let(:response_double) { double('response') }
      let(:response_body) { { rule_results: { points_awarded: { points: 10, coins: 2 }, achievements_awarded: [{ achievement_id: 1 }, { achievement_id: 2 }] } }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(true)

        allow(HTTParty).to receive(:post).and_return(response_double)
      end

      it 'should call the post method on HTTParty' do
        expect(HTTParty).to receive(:post).with(URI.parse(request_path), { body: request_body, headers: expected_headers.deep_stringify_keys })

        GameServer::Admin::Request::ExternalEventRequest.new().log_event(player_ext_id, external_event_id)
      end

      it 'should return the response object' do
        create_event_response = GameServer::Admin::Request::ExternalEventRequest.new().log_event(player_ext_id, external_event_id)

        expect(create_event_response.success).to eq(true)
        expect(create_event_response.error_message).to eq(nil)

        points_awarded = create_event_response.points_awarded
        expect(points_awarded.count).to eq(2)
        expect(points_awarded[0].point_type).to eq(:points)
        expect(points_awarded[0].count).to eq(10)
        expect(points_awarded[1].point_type).to eq(:coins)
        expect(points_awarded[1].count).to eq(2)

        achievements_awarded = create_event_response.achievements_awarded
        expect(achievements_awarded.count).to eq(2)
        expect(achievements_awarded[0].achievement_id).to eq(1)
        expect(achievements_awarded[1].achievement_id).to eq(2)
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
        create_event_response = GameServer::Admin::Request::ExternalEventRequest.new().log_event(player_ext_id, external_event_id)

        expect(create_event_response.success).to eq(false)
        expect(create_event_response.error_message).to eq('error')
        expect(create_event_response.points_awarded).to eq(nil)
        expect(create_event_response.achievements_awarded).to eq(nil)
      end
    end
  end

end