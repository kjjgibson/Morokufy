require 'rails_helper'
require 'morokufy_hip_chat_notifications'
require 'hip_chat/hip_chat_request'
require 'game_server/admin/request/external_event_request'
require 'game_server/model/player'
require 'game_server/model/player_point_type'

describe 'MorokufyHipChatNotificationsSpec' do

  describe '#send_points_awarded_notification' do
    let(:name) { 'Bob' }
    let(:email) { 'bob@gmail.com' }
    let(:username) { 'bobby_bob' }
    let(:name_alias) { FactoryGirl.build(:alias, alias_value: name, alias_type: Alias::AliasType::NAME) }
    let(:email_alias) { FactoryGirl.build(:alias, alias_value: email, alias_type: Alias::AliasType::EMAIL) }
    let(:username_alias) { FactoryGirl.build(:alias, alias_value: username, alias_type: Alias::AliasType::USERNAME) }
    let(:gs_player) { GameServer::Model::Player.new('', '', '', '') }

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

        MorokufyHipChatNotifications.new().send_points_awarded_notification(10, 'Points', player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    context 'with an email alias' do
      let(:selected_alias_value) { email_alias.alias_value }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [username_alias, email_alias])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(10, 'Points', player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    context 'with a username alias' do
      let(:selected_alias_value) { username_alias.alias_value }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [username_alias])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(10, 'Points', player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
      end
    end

    context 'with no alias' do
      let(:selected_alias_value) { 'Unknown Player' }

      it 'should send the request' do
        expect_send_room_notification()

        player = FactoryGirl.create(:player, aliases: [])

        MorokufyHipChatNotifications.new().send_points_awarded_notification(10, 'Points', player, gs_player, GameServer::Admin::Request::ExternalEventRequest::EventTypes::SEMAPHORE_BUILD_PASSED_EVENT)
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
        expect(attributes[0].value.label).to eq('110')
        expect(attributes[1].label).to eq('Coins')
        expect(attributes[1].value.label).to eq('10')
        expect(attributes[2].label).to eq('Achievements')
        expect(attributes[2].value.label).to eq('3')
      end
    end
  end

end