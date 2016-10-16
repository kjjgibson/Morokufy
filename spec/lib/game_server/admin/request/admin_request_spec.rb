require 'rails_helper'
require 'game_server/admin/request/admin_request'

describe 'AdminRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy/admin#{resource_path}" }
  let(:resource_path) { '/giraffes' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { mock_headers.merge({ 'Content-Type': 'application/json' }) }

  describe '#post' do
    let(:body) { { awesome_param: 'cool' } }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with(body.to_json, URI.parse(request_path), 'POST').and_return(mock_headers)
    end

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(URI.parse(request_path), { body: body.to_json, headers: expected_headers.stringify_keys })

      GameServer::Admin::Request::AdminRequest.new().post(resource_path, body)
    end
  end

  describe '#get' do
    let(:body) { { } }
    let(:resource_id) { 10 }
    let(:resource_request_path) { "#{request_path}/#{resource_id}" }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with(body.to_json, URI.parse(request_path), 'GET').and_return(mock_headers)
    end

    it 'should call the get method on HTTParty' do
      expect(HTTParty).to receive(:get).with(URI.parse(resource_request_path), { headers: mock_headers })

      GameServer::Admin::Request::AdminRequest.new().get(resource_path, resource_id)
    end
  end

end