require 'game_server/model/player_point_type'
require 'game_server/model/player'
require 'game_server/admin/request/external_event_request'
require 'game_server/admin/request/achievement_request'

# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  api_key       :string
#  shared_secret :string
#  identifier    :string
#

require 'rails_helper'
require 'shoulda-matchers'

describe Player, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:player)).to be_valid()
  end

  describe 'validations' do
    it { should validate_presence_of(:identifier) }
  end

  describe 'associations' do
    it { should have_many(:aliases) }
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
      allow_any_instance_of(MorokufyHipChatNotifications).to receive(:send_achievement_awarded_notification).and_return(true)
    end

    context 'successful Game Server request' do
      before do
        allow(log_event_response_double).to receive(:is_success?).and_return(true)
      end

      it 'should call the request class to make the request' do
        expect_any_instance_of(GameServer::Admin::Request::ExternalEventRequest).to receive(:log_event).with(player.identifier, event_name)

        player.log_event(event_name, gs_player)
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
            player.log_event(event_name, gs_player)
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
          expect_any_instance_of(MorokufyHipChatNotifications).to receive(:send_points_awarded_notification) do |_, points_awarded, player_param, gs_player_param, event_name_param|
            expect(points_awarded).to eq(points_awarded)
            expect(player_param).to eq(player)
            expect(gs_player_param).to eq(gs_player)
            expect(gs_player_param.player_point_types.first.count).to eq(1100)
            expect(event_name_param).to eq(event_name)
          end

          player.log_event(event_name, gs_player)
        end
      end

      context 'with achievements awarded' do
        let(:achievement_award_1) { GameServer::Model::RuleResultAchievementAward.new(1) }
        let(:achievement_award_2) { GameServer::Model::RuleResultAchievementAward.new(2) }
        let(:achievements_awarded) { [achievement_award_1, achievement_award_2] }
        let(:achievement) { GameServer::Model::Achievement.new('name', 'description', 'image_url') }

        before do
          allow(log_event_response_double).to receive(:points_awarded).and_return(nil)
          allow(log_event_response_double).to receive(:achievements_awarded).and_return(achievements_awarded)

          get_achievement_double = double('get_achievement')
          allow_any_instance_of(GameServer::Admin::Request::AchievementRequest).to receive(:get_achievement).and_return(get_achievement_double)
          allow(get_achievement_double).to receive(:achievement).and_return(achievement)
        end

        it 'should create RuleConsequentEvents for each achievement awarded' do
          expect do
            player.log_event(event_name, gs_player)
          end.to change(RuleConsequentEvent, :count).by(2)

          rule_consequent_event = RuleConsequentEvent.find_by_achievement_id(achievement_award_1.achievement_id)
          expect(rule_consequent_event.consequent_type).to eq(RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT)
          expect(rule_consequent_event.event_name).to eq(event_name)

          rule_consequent_event = RuleConsequentEvent.find_by_achievement_id(achievement_award_2.achievement_id)
          expect(rule_consequent_event.consequent_type).to eq(RuleConsequentEvent::ConsequentType::ACHIEVEMENT_CONSEQUENT)
          expect(rule_consequent_event.event_name).to eq(event_name)
        end

        it 'should send a HipChat notification for the Achievement' do
          expect_any_instance_of(MorokufyHipChatNotifications).to receive(:send_achievement_awarded_notification) do |_, achievement_param, player_param|
            expect(achievement_param).to eq(achievement)
            expect(player_param).to eq(player)
          end

          player.log_event(event_name, gs_player)
        end
      end

      context 'with no points or achievements awarded' do
        it 'should not create any RuleConsequentEvents' do
          expect do
            player.log_event(event_name, gs_player)
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
          player.log_event(event_name, gs_player)
        end.to change(RuleConsequentEvent, :count).by(0)
      end
    end
  end

end
