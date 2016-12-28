require 'rails_helper'
require 'morokufy_hip_chat_notifications'
require 'hip_chat/hip_chat_request'
require 'game_server/admin/request/external_event_request'
require 'game_server/model/player'
require 'game_server/model/player_point_type'
require 'game_server/model/rule_result_points_award'

describe 'MorokufyHipChatNotificationsSpec' do

  describe '#send_achievement_awarded_notification' do

    it 'should send the request' do
      expect_send_achievement_notification('name', 'description', 'url', 'bob')

      MorokufyHipChatNotifications.new().send_achievement_awarded_notification('name', 'description', 'url', 'bob')
    end

    private def expect_send_achievement_notification(achievement_name, achievement_description, achievement_image_url, player_name)
      expect_any_instance_of(HipChat::HipChatRequest).to receive(:send_room_notification) do |_, room, room_notification|
        expect(room.room_id).to eq('test_room_id')
        expect(room.room_auth_token).to eq('test_room_auth_token')

        expect(room_notification.color).to eq('gray')
        expect(room_notification.message).to eq("#{player_name} has been awarded the \"#{achievement_name}\" Achievement")
        expect(room_notification.notify).to eq(false)

        card = room_notification.card
        expect(card).not_to eq(nil)
        expect(card.title).to eq("#{player_name} has been awarded the \"#{achievement_name}\" Achievement")

        description = card.description
        expect(description).not_to eq(nil)
        expect(description.value).to eq(achievement_description)
        expect(description.format).to eq('html')

        thumbnail = card.thumbnail
        expect(thumbnail).not_to eq(nil)
        expect(thumbnail.url).to eq(achievement_image_url)
      end
    end
  end

  describe '#send_points_awarded_notification' do
    let(:name) { 'Bob' }
    let(:email) { 'bob@gmail.com' }
    let(:username) { 'bobby_bob' }
    let(:name_alias) { FactoryGirl.build(:alias, alias_value: name, alias_type: Alias::AliasType::NAME) }
    let(:email_alias) { FactoryGirl.build(:alias, alias_value: email, alias_type: Alias::AliasType::EMAIL) }
    let(:username_alias) { FactoryGirl.build(:alias, alias_value: username, alias_type: Alias::AliasType::USERNAME) }
    let(:gs_player) { GameServer::Model::Player.new('', '', '', '') }
    let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', 10)] }
    let(:selected_alias_value) { name_alias.alias_value }

    before do
      allow_any_instance_of(HipChat::HipChatRequest).to receive(:send_room_notification).and_return(true)

      gs_player.player_point_types = [GameServer::Model::PlayerPointType.new(point_name: 'Points', count: 100,),
                                      GameServer::Model::PlayerPointType.new(point_name: 'Coins', count: 10,)]
      gs_player.achievement_awards = [0, 0, 0] # We only care about the size of this array, not what's in it - so fill it with anything
    end

    context 'with a name alias' do
      let(:selected_alias_value) { name_alias.alias_value }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [username_alias, email_alias, name_alias])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(points_awarded, player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    context 'with an email alias' do
      let(:selected_alias_value) { email_alias.alias_value }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [username_alias, email_alias])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(points_awarded, player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    context 'with a username alias' do
      let(:selected_alias_value) { username_alias.alias_value }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [username_alias])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(points_awarded, player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    context 'with no alias' do
      let(:selected_alias_value) { 'Unknown Player' }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(points_awarded, player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    describe 'build_points_awarded_string' do
      let(:player) { FactoryGirl.create(:player, aliases: [name_alias]) }
      let(:send_points_awarded_notification_action) { MorokufyHipChatNotifications.new().send_points_awarded_notification(points_awarded, player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT) }

      context 'award points' do
        context 'single point type' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', 10)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has been awarded <b>10</b> Points')

            send_points_awarded_notification_action
          end
        end

        context 'two point types' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', 10), GameServer::Model::RuleResultPointsAward.new('Coins', 5)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has been awarded <b>10</b> Points and <b>5</b> Coins')

            send_points_awarded_notification_action
          end
        end

        context 'three point types' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', 10), GameServer::Model::RuleResultPointsAward.new('Coins', 5), GameServer::Model::RuleResultPointsAward.new('Gems', 1)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has been awarded <b>10</b> Points, <b>5</b> Coins, and <b>1</b> Gems')

            send_points_awarded_notification_action
          end
        end
      end

      context 'deduct points' do
        context 'single point type' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', -10)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has lost <b>10</b> Points')

            send_points_awarded_notification_action
          end
        end

        context 'two point types' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', -10), GameServer::Model::RuleResultPointsAward.new('Coins', -5)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has lost <b>10</b> Points and <b>5</b> Coins')

            send_points_awarded_notification_action
          end
        end

        context 'three point types' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', -10), GameServer::Model::RuleResultPointsAward.new('Coins', -5), GameServer::Model::RuleResultPointsAward.new('Gems', -1)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has lost <b>10</b> Points, <b>5</b> Coins, and <b>1</b> Gems')

            send_points_awarded_notification_action
          end
        end
      end

      context 'award and deduct points' do
        context 'two point types' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', 10), GameServer::Model::RuleResultPointsAward.new('Coins', -5)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has been awarded <b>10</b> Points. <b>Bob</b> has lost <b>5</b> Coins')

            send_points_awarded_notification_action
          end
        end

        context 'three point types' do
          let(:points_awarded) { [GameServer::Model::RuleResultPointsAward.new('Points', 10), GameServer::Model::RuleResultPointsAward.new('Coins', -5), GameServer::Model::RuleResultPointsAward.new('Gems', 1)] }

          it 'should generate the correct string' do
            expect_send_room_notification_with_activity_html('<b>Bob</b> has been awarded <b>10</b> Points and <b>1</b> Gems. <b>Bob</b> has lost <b>5</b> Coins')

            send_points_awarded_notification_action
          end
        end
      end
    end

    private def expect_send_room_notification
      expect_any_instance_of(HipChat::HipChatRequest).to receive(:send_room_notification) do |_, room, room_notification|
        expect(room.room_id).to eq('test_room_id')
        expect(room.room_auth_token).to eq('test_room_auth_token')

        expect(room_notification.color).to eq('gray')
        expect(room_notification.message).to eq("<b>#{selected_alias_value}</b> has been awarded <b>10</b> Points")
        expect(room_notification.notify).to eq(false)

        card = room_notification.card
        expect(card).not_to eq(nil)
        expect(card.format).to eq('medium')
        expect(card.title).to eq('Morokufy')

        description = card.description
        expect(description).not_to eq(nil)
        expect(description.value).to eq("<b>#{selected_alias_value}</b> has been awarded <b>10</b> Points for a successful Semaphore build.")
        expect(description.format).to eq('html')

        icon = card.icon
        expect(icon).not_to eq(nil)
        expect(icon.url).to eq('http://moroku.com/wp-content/uploads/2015/12/weblogo150-50-copy.png')

        activity = card.activity
        expect(activity).not_to eq(nil)
        expect(activity.html).to eq("<b>#{selected_alias_value}</b> has been awarded <b>10</b> Points")

        attributes = card.attributes
        expect(attributes.count).to eq(3)
        expect(attributes[0].label).to eq('Points')
        expect(attributes[0].value.label).to eq('100')
        expect(attributes[1].label).to eq('Coins')
        expect(attributes[1].value.label).to eq('10')
        expect(attributes[2].label).to eq('Achievements')
        expect(attributes[2].value.label).to eq('3')
      end
    end

    private def expect_send_room_notification_with_activity_html(html)
      expect_any_instance_of(HipChat::HipChatRequest).to receive(:send_room_notification) do |_, _, room_notification|
        card = room_notification.card
        activity = card.activity

        expect(activity.html).to eq(html)
      end
    end

  end

end