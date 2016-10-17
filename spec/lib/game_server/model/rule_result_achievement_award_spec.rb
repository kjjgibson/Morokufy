require 'game_server/model/rule_result_achievement_award'

describe 'RuleResultAchievementAward' do

  describe '#initialize' do
    it 'sets the attributes' do
      achievement_award = GameServer::Model::RuleResultAchievementAward.new(10)

      expect(achievement_award.achievement_id).to eq(10)
    end
  end

end