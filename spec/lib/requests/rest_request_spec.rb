require 'rails_helper'
require 'game_server/requests/rest_request'

describe 'RestRequest' do

  let(:request_path) { "http://gameserver-morokufy.herokuapp.com/morokufy#{resource_path}" }
  let(:resource_path) { '/giraffes' }
  let(:mock_headers) { { 'Authorization': '123 : abc' } }

  before do
    # Mock the call to create the authentication headers
    allow(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).and_return(mock_headers)
  end

  describe '.post' do

    let(:body) { { awesome_param: 'cool' } }

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(URI.parse(request_path), { body: body.to_json, headers: mock_headers })

      GameServer::Requests::RestRequest.post(resource_path, body)
    end

    it 'should perform the request' do
      request_stub = stub_request(:post, request_path).with(body: body.to_json, headers: mock_headers)

      GameServer::Requests::RestRequest.post(resource_path, body)

      expect(request_stub).to have_been_requested
    end

    it 'should return the response object' do
      response_double = double('response')
      allow(HTTParty).to receive(:post).and_return(response_double)

      response = GameServer::Requests::RestRequest.post(resource_path, body)

      expect(response).to eq(response_double)
    end
  end

  describe '.get' do

    let(:resource_id) { 10 }
    let(:resource_request_path) { "#{request_path}/#{resource_id}" }

    it 'should call the get method on HTTParty' do
      expect(HTTParty).to receive(:get).with(URI.parse(resource_request_path), { body: {}.to_json, headers: mock_headers })

      GameServer::Requests::RestRequest.get(resource_path, resource_id)
    end

    it 'should perform the request' do
      request_stub = stub_request(:get, resource_request_path).with(headers: mock_headers)

      GameServer::Requests::RestRequest.get(resource_path, resource_id)

      expect(request_stub).to have_been_requested
    end

    it 'should return the response object' do
      response_double = double('response')
      allow(HTTParty).to receive(:get).and_return(response_double)

      response = GameServer::Requests::RestRequest.get(resource_path, resource_id)

      expect(response).to eq(response_double)
    end
  end

end