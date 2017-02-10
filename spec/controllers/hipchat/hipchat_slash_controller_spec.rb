require 'rails_helper'

describe Hipchat::HipchatSlashController, type: :controller do

  describe '#create' do
    let(:request_body) { {
        "event": "room_message",
        "item": {
            "message": {
                "date": "2015-01-20T22:45:06.662545+00:00",
                "from": {
                    "id": 1661743,
                    "mention_name": "Blinky",
                    "name": "matbutton"
                },
                "id": "00a3eb7f-fac5-496a-8d64-a9050c712ca1",
                "mentions": [],
                "message": "/stats",
                "type": "message"
            },
            "room": {
                "id": 1147567,
                "name": "The Weather Channel"
            }
        },
        "webhook_id": 578829
    } }

    context 'receiving valid slash command data' do
      it 'should return 200' do
        post :create, params: request_body
        expect(response.response_code).to eq(200)
      end

      context 'respond with morokufy player data' do
        before do
          player = FactoryGirl.create(:player, identifier:"matbutton")
          FactoryGirl.create(:alias, player:player,alias_value:"matbutton")

          card_attribute_value = HipChat::CardAttributeValue.new(label: "10")
          card_attribute = HipChat::CardAttribute.new(label: "cheese", value: card_attribute_value)

          gs_player = double("gs_player")
          allow_any_instance_of(MorokufyPlayerHelper).to receive(:get_gs_player).and_return(gs_player)
          allow_any_instance_of(MorokufyHipChatNotifications).to receive(:attributes_for_point_types).and_return([card_attribute])

        end

        it 'should contain the players points' do
          post :create, params: request_body
          # almost certain this is not what I'm supposed to do
          # but I'm losing my patience
          attributes = JSON.parse(response.body)["card"]["attributes"][0]
          expect(attributes["label"]).to eq("cheese")
          expect(attributes["value"]["label"]).to eq("10")
        end
      end

    end

  end

end