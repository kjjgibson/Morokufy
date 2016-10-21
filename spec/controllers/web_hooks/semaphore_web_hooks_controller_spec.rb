require 'rails_helper'

describe WebHooks::SemaphoreWebHooksController, type: :controller do

  describe '#create' do

    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:result) { 'passed' }
    let(:request_body) { { commit: { author_name: name, author_email: email }, result: result } }

    before do
      allow(controller).to receive(:create_or_get_player).and_return(nil)
      allow(controller).to receive(:log_event).and_return(nil)
      allow(controller).to receive(:get_game_server_player).and_return(nil)
    end

    it 'should attempt to create the player if it does not exist' do
      expect(controller).to receive(:create_or_get_player) do |name_alias, email_alias|
        expect(name_alias.alias_value).to eq(name)
        expect(name_alias.alias_type).to eq(Alias::AliasType::NAME)
        expect(email_alias.alias_value).to eq(email)
        expect(email_alias.alias_type).to eq(Alias::AliasType::EMAIL)
      end

      post :create, params: request_body
    end

    context 'successful player create' do
      let(:mf_player) { FactoryGirl.build(:player) }

      before do
        allow(controller).to receive(:create_or_get_player).and_return(mf_player)
      end

      it 'should get the gs player from the server' do
        expect(controller).to receive(:get_game_server_player).with(mf_player)

        post :create, params: request_body
      end

      context 'successful get gs player' do
        let(:gs_player) { GameServer::Model::Player.new('', '', '', '')}

        before do
          allow(controller).to receive(:get_game_server_player).and_return(gs_player)
        end

        context 'passed build' do
          let(:result) { 'passed' }

          it 'should log the event' do
            expect(controller).to receive(:log_event).with(mf_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT, gs_player).and_return(nil)

            post :create, params: request_body
          end
        end

        context 'failed build' do
          let(:result) { 'failed' }

          it 'should log the event' do
            expect(controller).to receive(:log_event).with(mf_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_FAILED_EVENT, gs_player).and_return(nil)

            post :create, params: request_body
          end
        end
      end

      context 'unsuccessful get gs player' do
        before do
          allow(controller).to receive(:get_game_server_player).and_return(nil)
        end

        it 'should not log any events' do
          expect(controller).not_to receive(:log_event)

          post :create, params: request_body
        end
      end
    end

    context 'unsuccessful player create' do
      it 'should not get the gs player' do
        expect(controller).not_to receive(:get_game_server_player)

        post :create, params: request_body
      end

      it 'should not log the event' do
        expect(controller).not_to receive(:log_event)

        post :create, params: request_body
      end
    end
  end

end