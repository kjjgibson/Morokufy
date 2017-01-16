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

    context 'should run' do
      it 'should return 200 not found' do
        post :create, params: request_body
        expect(response.response_code).to eq(200)
      end
    end

  end

end