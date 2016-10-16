require 'rails_helper'

describe WebHooks::SemaphoreWebHooksController, type: :controller do

  describe '#create' do

    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:result) { 'passed' }
    let(:request_body) { { commit: { author_name: name, author_email: email }, result: result } }

    before do
      allow(controller).to receive(:create_player_if_does_not_exist).and_return(nil)
      allow(controller).to receive(:log_event).and_return(nil)
    end

    it 'should attempt to create the player if it does not exist' do
      expect(controller).to receive(:create_player_if_does_not_exist).with(name, email)

      post :create, params: request_body
    end

    context 'passed build' do
      let(:result) { 'passed' }

      it 'should log the event' do
        expect(controller).to receive(:log_event).with(email, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT).and_return(nil)

        post :create, params: request_body
      end
    end

    context 'failed build' do
      let(:result) { 'failed' }

      it 'should log the event' do
        expect(controller).to receive(:log_event).with(email, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT).and_return(nil)

        post :create, params: request_body
      end
    end
  end

end