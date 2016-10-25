require 'rails_helper'
require 'request'

describe 'Request' do

  let(:request_path) { "http://moroku.hipchat.com/" }
  let(:headers) { { 'Authorization': '123 : abc' } }
  let(:expected_headers) { headers.merge({ 'Content-Type': 'application/json' }) }

  describe '#post' do

    let(:body) { { awesome_param: 'cool' } }

    it 'should call the post method on HTTParty' do
      expect(HTTParty).to receive(:post).with(request_path, { body: body.to_json, headers: expected_headers.stringify_keys })

      Request.new().post(request_path, body, headers: headers)
    end

    it 'should perform the request' do
      request_stub = stub_request(:post, request_path).with(body: body.to_json, headers: expected_headers.stringify_keys)

      Request.new().post(request_path, body, headers: headers)

      expect(request_stub).to have_been_requested
    end

    it 'should return the response object' do
      response_double = double('response')
      allow(HTTParty).to receive(:post).and_return(response_double)

      response = Request.new().post(request_path, body, headers: headers)

      expect(response).to eq(response_double)
    end
  end

end