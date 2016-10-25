require 'rails_helper'
require 'game_server/game_server_request'

describe 'GameServerRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy#{resource_path}" }
  let(:resource_path) { '/giraffes' }
  let(:headers) { { Date: '20161016 07:21:17 UTC', 'Content-MD5': 'xyz', 'Authorization': '123 : abc' } }
  let(:expected_headers) { headers.merge({ 'Content-Type': 'application/json' }) }

  describe '#post' do

    let(:body) { { nickname: 'nickname', ext_id: 'ext_id' } }

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(URI.parse(request_path), { body: body.to_json, headers: expected_headers.stringify_keys })

      GameServer::GameServerRequest.new().post(resource_path, body, headers: headers)
    end

    it 'should perform the request' do
      request_stub = stub_request(:post, request_path).with(body: body.to_json, headers: expected_headers)

      GameServer::GameServerRequest.new().post(resource_path, body, headers: headers)

      expect(request_stub).to have_been_requested
    end

    it 'should return the response object' do
      response_double = double('response')
      allow(HTTParty).to receive(:post).and_return(response_double)

      response = GameServer::GameServerRequest.new().post(resource_path, body, headers: headers)

      expect(response).to eq(response_double)
    end
  end

  describe '#get' do

    let(:resource_id) { 'bob@gmail.com' }
    let(:resource_request_path) { "#{request_path}/bob%40gmail%2Ecom" }

    it 'should call the get method on HTTParty' do
      expect(HTTParty).to receive(:get).with(URI.parse(resource_request_path), { headers: headers.stringify_keys })

      GameServer::GameServerRequest.new().get(resource_path, resource_id, headers: headers)
    end

    it 'should perform the request' do
      request_stub = stub_request(:get, resource_request_path).with(headers: headers)

      GameServer::GameServerRequest.new().get(resource_path, resource_id, headers: headers)

      expect(request_stub).to have_been_requested
    end

    it 'should return the response object' do
      response_double = double('response')
      allow(HTTParty).to receive(:get).and_return(response_double)

      response = GameServer::GameServerRequest.new().get(resource_path, resource_id, headers: headers)

      expect(response).to eq(response_double)
    end
  end

end