require 'rails_helper'
require 'game_server/admin/request/achievement_request'

describe 'AchievementRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy/admin#{resource_path}" }
  let(:resource_path) { '/achievements' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }

  describe '#get_achievement' do
    let(:achievement_id) { '1' }

    before do
      allow(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with('', URI.parse('/morokufy/admin/achievements/1'), 'GET').and_return(mock_headers)
    end

    context 'successful request' do

      let(:response_double) { double('response') }
      let(:response_body) { { name: 'name', description: 'description', image_url: 'image_url' }.to_json }

      before do
        allow(response_double).to receive(:body).and_return(response_body)
        allow(response_double).to receive(:success?).and_return(true)

        allow(HTTParty).to receive(:get).and_return(response_double)
      end

      it 'should call the get method on HTTParty' do
        expect(HTTParty).to receive(:get).with(URI.parse('http://gameserver-morokufy.herokuapp.com/morokufy/admin/achievements/1'), headers: mock_headers.stringify_keys)

        GameServer::Admin::Request::AchievementRequest.new().get_achievement(achievement_id)
      end

      it 'should return the response object' do
        get_achievement_response = GameServer::Admin::Request::AchievementRequest.new().get_achievement(achievement_id)

        expect(get_achievement_response.success).to eq(true)
        expect(get_achievement_response.error_message).to eq(nil)

        achievement = get_achievement_response.achievement
        expect(achievement).not_to eq(nil)
        expect(achievement.name).to eq('name')
        expect(achievement.description).to eq('description')
        expect(achievement.image_url).to eq('image_url')
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
        get_achievement_response = GameServer::Admin::Request::AchievementRequest.new().get_achievement(achievement_id)

        expect(get_achievement_response.success).to eq(false)
        expect(get_achievement_response.error_message).to eq('error')
        expect(get_achievement_response.achievement).to eq(nil)
      end
    end
  end

end