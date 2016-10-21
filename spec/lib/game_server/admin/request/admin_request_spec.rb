require 'rails_helper'
require 'game_server/admin/request/admin_request'

describe 'AdminRequest' do

  let(:mock_headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { mock_headers.merge({ 'Content-Type': 'application/json' }) }

  describe '#post' do
    let(:body) { { awesome_param: 'cool' } }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with(body.to_json, URI.parse('/morokufy/admin/giraffes'), 'POST').and_return(mock_headers)
    end

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(URI.parse('http://gameserver-morokufy.herokuapp.com/morokufy/admin/giraffes'), { body: body.to_json, headers: expected_headers.stringify_keys })

      GameServer::Admin::Request::AdminRequest.new().post('/giraffes', body)
    end
  end

  describe '#get' do
    let(:body) { { } }
    let(:resource_id) { 10 }
    let(:resource_request_path) { "#{request_path}/#{resource_id}" }

    before do
      expect(GameServer::AuthenticationHelper).to receive(:admin_gs_headers).with(body.to_json, URI.parse('/morokufy/admin/giraffes/10'), 'GET').and_return(mock_headers)
    end

    it 'should call the get method on HTTParty' do
      expect(HTTParty).to receive(:get).with(URI.parse('http://gameserver-morokufy.herokuapp.com/morokufy/admin/giraffes/10'), { headers: mock_headers.stringify_keys })

      GameServer::Admin::Request::AdminRequest.new().get('/giraffes', resource_id)
    end
  end

end