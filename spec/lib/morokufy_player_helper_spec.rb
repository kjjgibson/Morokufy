require 'rails_helper'
require 'morokufy_player_helper'
require 'game_server/client/request/player_request'

describe 'MorokufyPlayerHelper' do

  describe '.get_player' do
    let(:player_name) { "steve" }
    before do
      player = FactoryGirl.create(:player, identifier: "steve")
      FactoryGirl.create(:alias, alias_value: "steve stevenson", player: player)
    end
    it 'should return a player' do
      player = MorokufyPlayerHelper.new().get_player("steve stevenson")
      expect(player.identifier).to eq("steve")
    end
  end

  describe '.get_gs_player' do
    let(:player) { FactoryGirl.create(:player, identifier: "steve") }
    let(:gs_player) { double("gs_player") }

    before do
      allow_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:get_player).and_return(gs_player)
      expect_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:initialize).with(player.api_key, player.shared_secret)
      expect_any_instance_of(GameServer::Client::Request::PlayerRequest).to receive(:get_player).with(player.identifier)
      allow(gs_player).to receive("player").and_return("steve")
    end
    #This tests nothing mat, come on
    it 'returns a gs_player when successful' do
      allow(gs_player).to receive(:is_success?).and_return(true)
      gs_player = MorokufyPlayerHelper.new().get_gs_player(player)
      expect(gs_player).to eq("steve")
    end

    it 'returns nil if not successful' do
      allow(gs_player).to receive(:is_success?).and_return(false)
      allow(gs_player).to receive(:error_message)
      gs_player = MorokufyPlayerHelper.new().get_gs_player(player)
      expect(gs_player).to eq(nil)
    end

  end

end