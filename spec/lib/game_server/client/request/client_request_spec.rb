require 'rails_helper'
require 'game_server/client/request/client_request'

describe 'ClientRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy/client#{resource_path}" }
  let(:resource_path) { '/giraffes' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { mock_headers.merge({ 'Content-Type': 'application/json' }) }
  let(:api_key) { '123' }
  let(:shared_secret) { 'abc' }

  describe '#post' do
    let(:body) { { awesome_param: 'cool' } }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:gs_headers).with(body.to_json, api_key, shared_secret, URI.parse(request_path), 'POST').and_return(mock_headers)
    end

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(URI.parse(request_path), { body: body.to_json, headers: expected_headers.stringify_keys })

      GameServer::Client::Request::ClientRequest.new(api_key, shared_secret).post(resource_path, body)
    end
  end

  describe '#get' do
    let(:body) { "" }
    let(:resource_id) { 10 }
    let(:resource_request_path) { "#{request_path}/#{resource_id}" }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:gs_headers).with(body, api_key, shared_secret, URI.parse(resource_request_path), 'GET').and_return(mock_headers)
    end

    it 'should call the get method on HTTParty' do
      expect(HTTParty).to receive(:get).with(URI.parse(resource_request_path), { headers: mock_headers.stringify_keys })

      GameServer::Client::Request::ClientRequest.new(api_key, shared_secret).get(resource_path, resource_id)
    end
  end

end