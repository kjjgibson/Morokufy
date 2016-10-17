require 'game_server/model/rule_result_points_award'

describe 'RuleResultPointsAward' do

  describe '#initialize' do
    it 'sets the attributes' do
      points_award = GameServer::Model::RuleResultPointsAward.new('Points', 100)

      expect(points_award.point_type).to eq('Points')
      expect(points_award.count).to eq(100)
    end
  end

end