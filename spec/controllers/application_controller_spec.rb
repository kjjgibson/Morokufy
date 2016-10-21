require 'rails_helper'
require 'game_server/admin/request/player_request'
require 'game_server/admin/request/external_event_request'
require 'game_server/model/rule_result_points_award'
require 'game_server/model/rule_result_achievement_award'
require 'game_server/model/player_point_type'
require 'game_server/client/request/player_request'
require 'game_server/client/response/get_player_response'

describe ApplicationController, type: :controller do

  describe '#create_or_get_player' do

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
            ApplicationController.new().create_or_get_player([name_alias])
          end.to change(Player, :count).by(0)
        end

        it 'should return the player' do
          player = ApplicationController.new().create_or_get_player([name_alias])

          expect(player).not_to eq(nil)
          expect(player).to eq(player)
        end

        it 'should add a new aliases' do
          player = nil
          expect do
            player = ApplicationController.new().create_or_get_player([name_alias, email_alias])
          end.to change(Alias, :count).by(1)

          expect(player.aliases.count).to eq(2)
          expect(player.aliases.last.alias_value).to eq(email_alias.alias_value)
          expect(player.aliases.last.alias_type).to eq(email_alias.alias_type)
        end
      end

      context 'with the second alias' do
        it 'should not create a player' do
          expect do
            ApplicationController.new().create_or_get_player([email_alias, name_alias])
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

          ApplicationController.new().create_or_get_player([name_alias])
        end

        it 'should create a MF player' do
          expect do
            ApplicationController.new().create_or_get_player([name_alias])
          end.to change(Player, :count).by(1)
        end

        it 'should return the player with the correct attributes' do
          player = ApplicationController.new().create_or_get_player([name_alias, email_alias])

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
            ApplicationController.new().create_or_get_player([name_alias])
          end.to change(Player, :count).by(0)
        end

        it 'should return nil' do
          player = ApplicationController.new().create_or_get_player([name_alias])

          expect(player).to eq(nil)
        end
      end
    end
  end

  describe '#get_game_server_player' do
    let(:morokufy_player) { FactoryGirl.build(:player) }
    let(:gs_player) { GameServer::Model::Player.new('', '', '', '') }
    let(:gs_response) { GameServer::Client::Response::GetPlayerResponse.new(true, nil, gs_player) }

    before do
      allow_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:get_player).and_return(gs_response)
    end

    it 'should call the PlayerRequest class to perform the request' do
      expect_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:get_player).with(morokufy_player.identifier)

      ApplicationController.new().get_game_server_player(morokufy_player)
    end

    context 'successful response' do
      it 'should return the player from the response' do
        player = ApplicationController.new().get_game_server_player(morokufy_player)

        expect(player).to eq(gs_player)
      end
    end

    context 'unsuccessful response' do
      let(:gs_response) { GameServer::Client::Response::GetPlayerResponse.new(false, 'error_message', nil) }

      it 'should return nil' do
        player = ApplicationController.new().get_game_server_player(morokufy_player)

        expect(player).to eq(nil)
      end
    end
  end

  describe '#log_event' do
    let(:log_event_response_double) { double('response') }
    let(:name_alias) { FactoryGirl.build(:alias, alias_value: 'Bob', alias_type: Alias::AliasType::NAME) }
    let(:player) { FactoryGirl.create(:player, aliases: [name_alias]) }
    let(:event_name) { 'event' }
    let(:gs_player) { GameServer::Model::Player.new('Bob', 'bob@gmail.com', '', '') }
    let(:player_point_types) { [GameServer::Model::PlayerPointType.new(point_name: 'Points', count: 1000), GameServer::Model::PlayerPointType.new(point_name: 'Coins', count: 100)] }

    before do
      gs_player.player_point_types = player_point_types
    end

    before do
      allow_any_instance_of(GameServer::Admin::Request::ExternalEventRequest).to receive(:log_event).and_return(log_event_response_double)

      allow(log_event_response_double).to receive(:points_awarded).and_return(nil)
      allow(log_event_response_double).to receive(:achievements_awarded).and_return(nil)

      allow_any_instance_of(MorokufyHipChatNotifications).to receive(:send_points_awarded_notification).and_return(true)
    end

    context 'successful Game Server request' do
      before do
        allow(log_event_response_double).to receive(:is_success?).and_return(true)
      end

      it 'should call the request class to make the request' do
        expect_any_instance_of(GameServer::Admin::Request::ExternalEventRequest).to receive(:log_event).with(player.identifier, event_name)

        ApplicationController.new().log_event(player, event_name, gs_player)
      end

      context 'with points awarded' do
        let(:point_type_points) { 'Points' }
        let(:point_count_points) { 100 }
        let(:point_type_coins) { 'Coins' }
        let(:point_count_coins) { 5 }
        let(:points_award_points) { GameServer::Model::RuleResultPointsAward.new(point_type_points, point_count_points) }
        let(:points_award_coins) { GameServer::Model::RuleResultPointsAward.new(point_type_coins, point_count_coins) }
        let(:points_awarded) { [points_award_points, points_award_coins] }

        before do
          allow(log_event_response_double).to receive(:points_awarded).and_return(points_awarded)
          allow(log_event_response_double).to receive(:achievements_awarded).and_return(nil)
        end

        it 'should create RuleConsequentEvents for each point type awarded' do
          expect do
            ApplicationController.new().log_event(player, event_name, gs_player)
          end.to change(RuleConsequentEvent, :count).by(2)

          rule_consequent_event = RuleConsequentEvent.find_by_point_type(point_type_points)
          expect(rule_consequent_event.consequent_type).to eq(RuleConsequentEvent::ConsequentType::POINTS_CONSEQUENT)
          expect(rule_consequent_event.point_count).to eq(point_count_points)
          expect(rule_consequent_event.event_name).to eq(event_name)

          rule_consequent_event = RuleConsequentEvent.find_by_point_type(point_type_coins)
          expect(rule_consequent_event.consequent_type).to eq(RuleConsequentEvent::ConsequentType::POINTS_CONSEQUENT)
          expect(rule_consequent_event.point_count).to eq(point_count_coins)
          expect(rule_consequent_event.event_name).to eq(event_name)
        end

        it 'should send a HipChat notification for each point type awarded' do
          expect_any_instance_of(MorokufyHipChatNotifications).to receive(:send_points_awarded_notification) do |_, points, point_type, player, gs_player, event_name|
            expect(points).to eq(point_count_points)
            expect(point_type).to eq(point_type_points)
            expect(player).to eq(player)
            expect(gs_player).to eq(gs_player)
            expect(event_name).to eq(event_name)
          end

          expect_any_instance_of(MorokufyHipChatNotifications).to receive(:send_points_awarded_notification) do |_, points, point_type, player, gs_player, event_name|
            expect(points).to eq(point_count_coins)
            expect(point_type).to eq(point_type_coins)
            expect(player).to eq(player)
            expect(gs_player).to eq(gs_player)
            expect(event_name).to eq(event_name)
          end

          ApplicationController.new().log_event(player, event_name, gs_player)
        end
      end

      context 'with achievements awarded' do
        let(:achievement_award_1) { GameServer::Model::RuleResultAchievementAward.new(1) }
        let(:achievement_award_2) { GameServer::Model::RuleResultAchievementAward.new(2) }
        let(:achievements_awarded) { [achievement_award_1, achievement_award_2] }

        before do
          allow(log_event_response_double).to receive(:points_awarded).and_return(nil)
          allow(log_event_response_double).to receive(:achievements_awarded).and_return(achievements_awarded)
        end

        it 'should create RuleConsequentEvents for each achievement awarded' do
          expect do
            ApplicationController.new().log_event(player, event_name, gs_player)
          end.to change(RuleConsequentEvent, :count).by(2)

          rule_consequent_event = RuleConsequentEvent.find_by_achievement_id(achievement_award_1.achievement_id)
          expect(rule_consequent_event.consequent_type).to eq(RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT)
          expect(rule_consequent_event.event_name).to eq(event_name)

          rule_consequent_event = RuleConsequentEvent.find_by_achievement_id(achievement_award_2.achievement_id)
          expect(rule_consequent_event.consequent_type).to eq(RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT)
          expect(rule_consequent_event.event_name).to eq(event_name)
        end
      end

      context 'with no points or achievements awarded' do
        it 'should not create any RuleConsequentEvents' do
          expect do
            ApplicationController.new().log_event(player, event_name, gs_player)
          end.to change(RuleConsequentEvent, :count).by(0)
        end
      end
    end

    context 'unsuccessful Game Server request' do
      before do
        allow(log_event_response_double).to receive(:is_success?).and_return(false)
        allow(log_event_response_double).to receive(:error_message).and_return('error')
      end

      it 'should not create any RuleConsequentEvents' do
        expect do
          ApplicationController.new().log_event(player, event_name, gs_player)
        end.to change(RuleConsequentEvent, :count).by(0)
      end
    end
  end

end