require 'rails_helper'

describe WebHooks::SemaphoreWebHooksController, type: :controller do

  describe '.build_made' do

    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:request_body) { { author_name: name, author_email: email } }

    it 'should return 200' do
      post :create, params: request_body

      expect(response.response_code).to eq(200)
    end

    context 'player does not exist' do
      it 'should create a player' do
        expect do
          post :create, params: request_body
        end.to change(Player, :count).by(1)
      end

      it 'should create a player with the correct attributes' do
        post :create, params: request_body

        player = Player.last
        expect(player.name).to eq(name)
        expect(player.email).to eq(email)
      end
    end

    context 'player already exists' do
      before do
        FactoryGirl.create(:player, email: email)
      end

      it 'should not create a player' do
        expect do
          post :create, params: request_body
        end.to change(Player, :count).by(0)
      end
    end
  end

end