require 'rails_helper'
require 'game_server/admin/request/player_request'
require 'game_server/admin/request/external_event_request'
require 'game_server/model/points_award'
require 'game_server/model/achievement_award'

describe ApplicationController, type: :controller do

  describe '#create_player_if_does_not_exist' do

    let(:name) { 'Bob' }
    let(:email) { 'bob@bob.com' }
    let(:request_body) { { author_name: name, author_email: email } }
    let(:create_player_response_double) { double('response') }

    before do
      allow_any_instance_of(GameServer::Admin::Request::PlayerRequest).to receive(:create_player).and_return(create_player_response_double)
    end

    context 'Player already exists' do
      before do
        FactoryGirl.create(:player, email: email)
      end

      it 'should not create a player' do
        expect do
          ApplicationController.new().create_player_if_does_not_exist(name, email)
        end.to change(Player, :count).by(0)
      end
    end

    context 'Player does not exist' do
      context 'successful Game Server request' do
        let(:api_key) { '123' }
        let(:shared_secret) { 'abc' }

        before do
          allow(create_player_response_double).to receive(:is_success?).and_return(true)
          allow(create_player_response_double).to receive(:api_key).and_return(api_key)
          allow(create_player_response_double).to receive(:shared_secret).and_return(shared_secret)
        end

        it 'should call the request class to make the request' do
          expect_any_instance_of(GameServer::Admin::Request::PlayerRequest).to receive(:create_player).with(email)

          ApplicationController.new().create_player_if_does_not_exist(name, email)
        end

        it 'should create a MF player' do
          expect do
            ApplicationController.new().create_player_if_does_not_exist(name, email)
          end.to change(Player, :count).by(1)
        end

        it 'should create a player with the correct attributes' do
          ApplicationController.new().create_player_if_does_not_exist(name, email)

          player = Player.last
          expect(player.name).to eq(name)
          expect(player.email).to eq(email)
          expect(player.api_key).to eq(api_key)
          expect(player.shared_secret).to eq(shared_secret)
        end
      end

      context 'unsuccessful Game Server request' do
        before do
          allow(create_player_response_double).to receive(:is_success?).and_return(false)
          allow(create_player_response_double).to receive(:error_message).and_return('error')
        end

        it 'should not create a player' do
          expect do
            ApplicationController.new().create_player_if_does_not_exist(name, email)
          end.to change(Player, :count).by(0)
        end
      end
    end

  end

  describe '#log_event' do
    let(:log_event_response_double) { double('response') }
    let(:email) { 'bob@bob.com' }
    let(:event_name) { 'event' }

    before do
      allow_any_instance_of(GameServer::Admin::Request::ExternalEventRequest).to receive(:log_event).and_return(log_event_response_double)

      allow(log_event_response_double).to receive(:points_awarded).and_return(nil)
      allow(log_event_response_double).to receive(:achievements_awarded).and_return(nil)
    end

    context 'successful Game Server request' do
      before do
        allow(log_event_response_double).to receive(:is_success?).and_return(true)
      end

      it 'should call the request class to make the request' do
        expect_any_instance_of(GameServer::Admin::Request::ExternalEventRequest).to receive(:log_event).with(email, event_name)

        ApplicationController.new().log_event(email, event_name)
      end

      context 'with points awarded' do
        let(:point_type_points) { 'Points' }
        let(:point_count_points) { 100 }
        let(:point_type_coins) { 'Coins' }
        let(:point_count_coins) { 5 }
        let(:points_award_points) { GameServer::Model::PointsAward.new(point_type_points, point_count_points) }
        let(:points_award_coins) { GameServer::Model::PointsAward.new(point_type_coins, point_count_coins) }
        let(:points_awarded) { [points_award_points, points_award_coins] }

        before do
          allow(log_event_response_double).to receive(:points_awarded).and_return(points_awarded)
          allow(log_event_response_double).to receive(:achievements_awarded).and_return(nil)
        end

        it 'should create RuleConsequentEvents for each point type awarded' do
          expect do
            ApplicationController.new().log_event(email, event_name)
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
      end

      context 'with achievements awarded' do
        let(:achievement_award_1) { GameServer::Model::AchievementAward.new(1) }
        let(:achievement_award_2) { GameServer::Model::AchievementAward.new(2) }
        let(:achievements_awarded) { [achievement_award_1, achievement_award_2] }

        before do
          allow(log_event_response_double).to receive(:points_awarded).and_return(nil)
          allow(log_event_response_double).to receive(:achievements_awarded).and_return(achievements_awarded)
        end

        it 'should create RuleConsequentEvents for each achievement awarded' do
          expect do
            ApplicationController.new().log_event(email, event_name)
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
            ApplicationController.new().log_event(email, event_name)
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
          ApplicationController.new().log_event(email, event_name)
        end.to change(RuleConsequentEvent, :count).by(0)
      end
    end
  end

end