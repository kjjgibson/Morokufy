require 'rails_helper'
require 'hip_chat/hip_chat_request'
require 'hip_chat/room'

describe 'HipChatRequest' do

  describe '#send_room_notification' do
    let(:room) { HipChat::Room.new(room_id: '123', room_auth_token: 'abc') }
    let(:room_notification) { HipChat::RoomNotification.new(message: 'message') }

    before do
      allow_any_instance_of(HipChat::HipChatRequest).to receive(:post).and_return(true)
    end

    context 'valid room notification' do
      it 'should call the post method' do
        expect_any_instance_of(HipChat::HipChatRequest).to receive(:post) do |_, url, body, options|
          expect(url).to eq('url/v2/room/123/notification')
          expect(body.symbolize_keys).to eq({ message: 'message' })
          expect(options.deep_symbolize_keys).to eq({ headers: { Authorization: 'Bearer abc' } })
        end

        HipChat::HipChatRequest.new(url: 'url').send_room_notification(room, room_notification)
      end

      it 'should return true' do
        res = HipChat::HipChatRequest.new(url: 'url').send_room_notification(room, room_notification)

        expect(res).to eq(true)
      end
    end

    context 'invalid room notification' do
      it 'should not call the post method' do
        room_notification.message = nil

        expect_any_instance_of(HipChat::HipChatRequest).not_to receive(:post)

        HipChat::HipChatRequest.new(url: 'url').send_room_notification(room, room_notification)
      end

      it 'should return false' do
        room_notification.message = nil

        res = HipChat::HipChatRequest.new(url: 'url').send_room_notification(room, room_notification)

        expect(res).to eq(false)
      end
    end
  end

end