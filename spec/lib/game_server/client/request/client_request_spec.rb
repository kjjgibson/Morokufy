require 'rails_helper'
require 'game_server/client/request/client_request'

describe 'ClientRequest' do

  let(:mock_headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { mock_headers.merge({ 'Content-Type': 'application/json' }) }
  let(:api_key) { '123' }
  let(:shared_secret) { 'abc' }

  describe '#post' do
    let(:body) { { awesome_param: 'cool' } }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:gs_headers).with(body.to_json, api_key, shared_secret, URI.parse('/morokufy/client/giraffes'), 'POST').and_return(mock_headers)
    end

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(URI.parse('http://gameserver-morokufy.herokuapp.com/morokufy/client/giraffes'), { body: body.to_json, headers: expected_headers.stringify_keys })

      GameServer::Client::Request::ClientRequest.new(api_key, shared_secret).post('/giraffes', body)
    end
  end

  describe '#get' do
    let(:body) { "" }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:gs_headers).with(body, api_key, shared_secret, URI.parse('/morokufy/client/giraffes/10'), 'GET').and_return(mock_headers)
    end

    it 'should call the get method on HTTParty' do
      expect(HTTParty).to receive(:get).with(URI.parse('http://gameserver-morokufy.herokuapp.com/morokufy/client/giraffes/10'), { headers: mock_headers.stringify_keys })

      GameServer::Client::Request::ClientRequest.new(api_key, shared_secret).get('/giraffes', 10)
    end
  end

end