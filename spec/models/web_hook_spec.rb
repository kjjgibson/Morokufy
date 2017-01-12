# == Schema Information
#
# Table name: web_hooks
#
#  id          :integer          not null, primary key
#  name        :string
#  request_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'
require 'shoulda-matchers'
require 'game_server/model/player'

describe WebHook, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook)).to be_valid
  end

  describe 'associations' do
    it { should have_many :web_hook_rules }
    it { should have_many :web_hook_alias_keys }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :source_identifier }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :source_identifier }
  end

  describe '#run' do
    let(:web_hook) { FactoryGirl.build(:web_hook) }
    let(:params) { { param: 'value' } }
    let(:player) { instance_double(Player) }
    let(:game_server_player) { instance_double(GameServer::Model::Player) }

    context 'aliases found' do
      before do
        allow(web_hook).to receive(:aliases_for_params).and_return([1])
      end

      context 'player found' do
        before do
          allow(web_hook).to receive(:create_or_get_player).and_return(player)
        end

        context 'GS player found' do
          before do
            allow(web_hook).to receive(:get_game_server_player).and_return(game_server_player)
          end

          it 'should evaluate the rules' do
            expect(web_hook).to receive(:evaluate_web_hook_rules).with(params, player, game_server_player)

            web_hook.run(params)
          end
        end

        context 'GS player not found' do
          before do
            allow(web_hook).to receive(:get_game_server_player).and_return(nil)
          end

          it 'should not evaluate the rules' do
            expect(web_hook).not_to receive(:evaluate_web_hook_rules)

            web_hook.run(params)
          end
        end
      end

      context 'can not get player' do
        before do
          allow(web_hook).to receive(:create_or_get_player).and_return(nil)
        end

        it 'should not evaluate the rules' do
          expect(web_hook).not_to receive(:evaluate_web_hook_rules)

          web_hook.run(params)
        end
      end
    end

    context 'no aliases' do
      before do
        allow(web_hook).to receive(:aliases_for_params).and_return([])
      end

      it 'should not evaluate the rules' do
        expect(web_hook).not_to receive(:evaluate_web_hook_rules)

        web_hook.run(params)
      end
    end
  end

  describe '#aliases_for_params' do
    let(:web_hook) { FactoryGirl.build(:web_hook, web_hook_alias_keys: web_hook_alias_keys) }

    context 'no web_hook_alias_keys' do
      let(:web_hook_alias_keys) { [] }

      it 'should return an empty array' do
        expect(web_hook.aliases_for_params({})).to eq([])
      end
    end

    context 'not found in params' do
      context 'single level key' do
        let(:web_hook_alias_keys) { [FactoryGirl.build(:web_hook_alias_key, alias_key: 'name')] }

        it 'should return an empty array' do
          expect(web_hook.aliases_for_params({})).to eq([])
        end
      end

      context 'multi level key' do
        let(:web_hook_alias_keys) { [FactoryGirl.build(:web_hook_alias_key, alias_key: 'user.name')] }

        it 'should return an empty array' do
          expect(web_hook.aliases_for_params({})).to eq([])
        end
      end
    end

    context 'found in params' do
      context 'single alias key' do
        context 'single level key' do
          let(:web_hook_alias_keys) { [FactoryGirl.build(:web_hook_alias_key, alias_key: 'name', alias_type: Alias::AliasType::NAME)] }

          it 'should return a single Alias' do
            aliases = web_hook.aliases_for_params({ name: 'Bob' })

            expect(aliases.count).to eq(1)
            expect(aliases.first.alias_type).to eq(Alias::AliasType::NAME)
            expect(aliases.first.alias_value).to eq('Bob')
          end
        end

        context 'multi level key' do
          let(:web_hook_alias_keys) { [FactoryGirl.build(:web_hook_alias_key, alias_key: 'user.name', alias_type: Alias::AliasType::NAME)] }

          it 'should return a single Alias' do
            aliases = web_hook.aliases_for_params({ user: { name: 'Bob' } })

            expect(aliases.count).to eq(1)
            expect(aliases.first.alias_type).to eq(Alias::AliasType::NAME)
            expect(aliases.first.alias_value).to eq('Bob')
          end
        end
      end

      context 'multiple alias keys' do
        let(:web_hook_alias_keys) { [FactoryGirl.build(:web_hook_alias_key, alias_key: 'user.name', alias_type: Alias::AliasType::NAME),
                                     FactoryGirl.build(:web_hook_alias_key, alias_key: 'user.email', alias_type: Alias::AliasType::EMAIL)] }


        it 'should return an array of Aliases' do
          aliases = web_hook.aliases_for_params({ user: { name: 'Bob', email: 'bob@bob.com' } })

          expect(aliases.count).to eq(2)
          expect(aliases.first.alias_type).to eq(Alias::AliasType::NAME)
          expect(aliases.first.alias_value).to eq('Bob')
          expect(aliases.second.alias_type).to eq(Alias::AliasType::EMAIL)
          expect(aliases.second.alias_value).to eq('bob@bob.com')
        end
      end
    end
  end

  describe '#evaluate_web_hook_rules' do
    let(:player) { FactoryGirl.create(:player) }
    let(:web_hook) { FactoryGirl.create(:web_hook, web_hook_rules: [web_hook_rule]) }
    let(:web_hook_rule) { FactoryGirl.build(:web_hook_rule, web_hook_consequents: [web_hook_consequent, web_hook_consequent]) }
    let(:web_hook_consequent) { FactoryGirl.build(:web_hook_consequent, event_name: 'event_name') }
    let(:params) { { param: 'value' } }
    let(:game_server_player) { GameServer::Model::Player.new('nickname', 'ext_id', 'avatar', 'theme') }

    context 'rule evaluates to true' do
      before do
        allow(web_hook_rule).to receive(:evaluate).and_return(true)
      end

      it 'should log an event for each consequent' do
        expect(player).to receive(:log_event).with(web_hook_consequent.event_name, game_server_player).twice

        web_hook.evaluate_web_hook_rules(params, player, game_server_player)
      end
    end

    context 'rule evaluates to false' do
      before do
        allow(web_hook_rule).to receive(:evaluate).and_return(false)
      end

      it 'should not log any events' do
        expect(player).not_to receive(:log_event)

        web_hook.evaluate_web_hook_rules(params, player, game_server_player)
      end
    end
  end

  describe '#create_or_get_player' do

    let(:web_hook) { FactoryGirl.create(:web_hook) }
    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:request_body) { { author_name: name, author_email: email } }
    let(:create_player_response_double) { double('response') }
    let(:api_key) { '123' }
    let(:shared_secret) { 'abc' }
    let(:name_alias) { FactoryGirl.build(:alias, alias_value: name, alias_type: Alias::AliasType::NAME) }
    let(:email_alias) { FactoryGirl.build(:alias, alias_value: email, alias_type: Alias::AliasType::EMAIL) }

    before do
      allow_any_instance_of(GameServer::Admin::Request::PlayerRequest).to receive(:create_player).and_return(create_player_response_double)
      allow(create_player_response_double).to receive(:is_success?).and_return(true)
      allow(create_player_response_double).to receive(:api_key).and_return(api_key)
      allow(create_player_response_double).to receive(:shared_secret).and_return(shared_secret)
    end

    context 'Player already exists' do
      before do
        FactoryGirl.create(:player, aliases: [FactoryGirl.build(:alias, alias_value: 'Bob')])
      end

      context 'with the first alias' do
        it 'should not create a player' do
          expect do
            web_hook.create_or_get_player([name_alias])
          end.to change(Player, :count).by(0)
        end

        it 'should return the player' do
          player = web_hook.create_or_get_player([name_alias])

          expect(player).not_to eq(nil)
          expect(player).to eq(player)
        end

        it 'should add a new aliases' do
          player = nil
          expect do
            player = web_hook.create_or_get_player([name_alias, email_alias])
          end.to change(Alias, :count).by(1)

          expect(player.aliases.count).to eq(2)
          expect(player.aliases.last.alias_value).to eq(email_alias.alias_value)
          expect(player.aliases.last.alias_type).to eq(email_alias.alias_type)
        end
      end

      context 'with the second alias' do
        it 'should not create a player' do
          expect do
            web_hook.create_or_get_player([email_alias, name_alias])
          end.to change(Player, :count).by(0)
        end
      end
    end

    context 'Player does not exist' do
      context 'successful Game Server request' do
        let(:api_key) { '123' }
        let(:shared_secret) { 'abc' }

        it 'should call the request class to make the request' do
          expect_any_instance_of(GameServer::Admin::Request::PlayerRequest).to receive(:create_player).with('bob')

          web_hook.create_or_get_player([name_alias])
        end

        it 'should create a MF player' do
          expect do
            web_hook.create_or_get_player([name_alias])
          end.to change(Player, :count).by(1)
        end

        it 'should return the player with the correct attributes' do
          player = web_hook.create_or_get_player([name_alias, email_alias])

          expect(player.identifier).to eq(name.downcase)
          expect(player.api_key).to eq(api_key)
          expect(player.shared_secret).to eq(shared_secret)
          expect(player.aliases.count).to eq(2)
          expect(player.aliases.first.alias_value).to eq(name)
          expect(player.aliases.second.alias_value).to eq(email)
        end
      end

      context 'unsuccessful Game Server request' do
        before do
          allow(create_player_response_double).to receive(:is_success?).and_return(false)
          allow(create_player_response_double).to receive(:error_message).and_return('error')
        end

        it 'should not create a player' do
          expect do
            web_hook.create_or_get_player([name_alias])
          end.to change(Player, :count).by(0)
        end

        it 'should return nil' do
          player = web_hook.create_or_get_player([name_alias])

          expect(player).to eq(nil)
        end
      end
    end
  end

  describe '#get_game_server_player' do
    let(:web_hook) { FactoryGirl.create(:web_hook) }
    let(:morokufy_player) { FactoryGirl.build(:player) }
    let(:gs_player) { GameServer::Model::Player.new('', '', '', '') }
    let(:gs_response) { GameServer::Client::Response::GetPlayerResponse.new(true, nil, gs_player) }

    before do
      allow_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:get_player).and_return(gs_response)
    end

    it 'should call the PlayerRequest class to perform the request' do
      expect_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:get_player).with(morokufy_player.identifier)

      web_hook.get_game_server_player(morokufy_player)
    end

    context 'successful response' do
      it 'should return the player from the response' do
        player = web_hook.get_game_server_player(morokufy_player)

        expect(player).to eq(gs_player)
      end
    end

    context 'unsuccessful response' do
      let(:gs_response) { GameServer::Client::Response::GetPlayerResponse.new(false, 'error_message', nil) }

      it 'should return nil' do
        player = web_hook.get_game_server_player(morokufy_player)

        expect(player).to eq(nil)
      end
    end
  end

end
