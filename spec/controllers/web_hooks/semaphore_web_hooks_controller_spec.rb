require 'rails_helper'

describe WebHooks::SemaphoreWebHooksController, type: :controller do

  describe '#create' do

    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:request_body) { { author_name: name, author_email: email } }
    let(:create_player_response_double) { double('response') }

    before do
      allow_any_instance_of(GameServer::Admin::Request::PlayerRequest).to receive(:create_player).and_return(create_player_response_double)
    end

    context 'player does not exist' do

      context 'successful request' do
        let(:api_key) { '123' }
        let(:shared_secret) { 'abc' }

        before do
          allow(create_player_response_double).to receive(:is_success?).and_return(true)
          allow(create_player_response_double).to receive(:api_key).and_return(api_key)
          allow(create_player_response_double).to receive(:shared_secret).and_return(shared_secret)
        end

        it 'should return 200' do
          post :create, params: request_body

          expect(response.response_code).to eq(200)
        end

        it 'should call the request class to make the request' do
          expect_any_instance_of(GameServer::Admin::Request::PlayerRequest).to receive(:create_player).with(email)

          post :create, params: request_body
        end

        it 'should create a MF player' do
          expect do
            post :create, params: request_body
          end.to change(Player, :count).by(1)
        end

        it 'should create a player with the correct attributes' do
          post :create, params: request_body

          player = Player.last
          expect(player.name).to eq(name)
          expect(player.email).to eq(email)
          expect(player.api_key).to eq(api_key)
          expect(player.shared_secret).to eq(shared_secret)
        end
      end

      context 'failed request' do
        before do
          allow(create_player_response_double).to receive(:is_success?).and_return(false)
          allow(create_player_response_double).to receive(:error_message).and_return('error')
        end

        it 'should return 200' do
          post :create, params: request_body

          expect(response.response_code).to eq(200)
        end

        it 'should not create a player' do
          expect do
            post :create, params: request_body
          end.to change(Player, :count).by(0)
        end
      end
    end

    context 'player already exists' do
      before do
        FactoryGirl.create(:player, email: email)
      end

      it 'should return 200' do
        post :create, params: request_body

        expect(response.response_code).to eq(200)
      end

      it 'should not create a player' do
        expect do
          post :create, params: request_body
        end.to change(Player, :count).by(0)
      end
    end
  end

end