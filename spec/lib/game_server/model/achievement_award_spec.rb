require 'game_server/model/achievement_award'

describe 'AchievementAward' do

  describe '#initialize' do
    it 'sets the attributes' do
      achievement_award = GameServer::Model::AchievementAward.new(10)

      expect(achievement_award.achievement_id).to eq(10)
    end
  end

end