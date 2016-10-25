require 'rails_helper'
require 'hip_chat/room_notification'

describe 'RoomNotification' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:room_notification)).to be_valid
    end

    it 'should validate the message presence' do
      expect(FactoryGirl.build(:room_notification, message: nil)).to be_invalid
    end

    it 'should validate the color' do
      expect(FactoryGirl.build(:room_notification, color: nil)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: HipChat::RoomNotification::Color::YELLOW)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: HipChat::RoomNotification::Color::GREEN)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: HipChat::RoomNotification::Color::RED)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: HipChat::RoomNotification::Color::PURPLE)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: HipChat::RoomNotification::Color::GRAY)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: HipChat::RoomNotification::Color::RANDOM)).to be_valid
      expect(FactoryGirl.build(:room_notification, color: 'blurple')).to be_invalid
    end

    it 'should validate the message_format' do
      expect(FactoryGirl.build(:room_notification, message_format: nil)).to be_valid
      expect(FactoryGirl.build(:room_notification, message_format: HipChat::RoomNotification::MessageFormat::HTML)).to be_valid
      expect(FactoryGirl.build(:room_notification, message_format: HipChat::RoomNotification::MessageFormat::TEXT)).to be_valid
      expect(FactoryGirl.build(:room_notification, message_format: 'klingon')).to be_invalid
    end

    it 'should validate the from length' do
      expect(FactoryGirl.build(:room_notification, from: '')).to be_valid
      expect(FactoryGirl.build(:room_notification, from: nil)).to be_valid
      expect(FactoryGirl.build(:room_notification, from: 'a' * 64)).to be_valid
      expect(FactoryGirl.build(:room_notification, from: 'a' * 65)).to be_invalid
    end
  end

end