require 'rails_helper'
require 'game_server/authentication_helper'

describe 'AuthenticationHelper' do

  before do
    Timecop.freeze(Time.at(0))
  end

  after do
    Timecop.return
  end

  describe '.gs_headers' do
    it 'returns the correct headers' do
      expect(GameServer::AuthenticationHelper.gs_headers('', '123', 'abc', '/giraffes', 'GET')).to eq({ 'Date': '19700101 00:00:00 UTC', 'Content-MD5': '1B2M2Y8AsgTpgAmY7PhCfg==', 'Authorization': '123 : 9ce290520f6dcb655a03058927537e99c456be64', 'Content-Type': 'application/json' })
    end
  end

  describe '.admin_gs_headers' do
    it 'returns the correct headers' do
      expect(GameServer::AuthenticationHelper.admin_gs_headers('', '/giraffes', 'GET')).to eq({ 'Date': '19700101 00:00:00 UTC', 'Content-MD5': '1B2M2Y8AsgTpgAmY7PhCfg==', 'Authorization': '0123456789 : 884a4c1f571d985b7ff4de29740ba35543f769ca', 'Content-Type': 'application/json' })
    end
  end

end