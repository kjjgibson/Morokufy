require 'rails_helper'

describe WebHooks::SemaphoreWebHooksController, type: :controller do

  describe '#create' do

    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:result) { 'passed' }
    let(:request_body) { { commit: { author_name: name, author_email: email }, result: result } }

    context 'no matching web hook' do
      it 'should return 404 not found' do
        post :create, params: request_body

        expect(response.response_code).to eq(404)
      end
    end

    context 'matching web hook' do
      let!(:web_hook) { FactoryGirl.create(:web_hook, request_url: 'http://test.host/web_hooks/semaphore_web_hooks') }

      it 'should run the web hook' do
        expect_any_instance_of(WebHook).to receive(:run)

        post :create, params: request_body
      end
    end
  end

end