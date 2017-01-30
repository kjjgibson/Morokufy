require 'rails_helper'
require 'shoulda-matchers'

describe RuleConsequentEvent, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:rule_consequent_event, :point_consequent)).to be_valid()
    expect(FactoryGirl.build(:rule_consequent_event, :achievement_consequent)).to be_valid()
  end

  describe 'validations' do
    it { should validate_presence_of(:consequent_type) }
    it { should validate_presence_of(:event_name) }
    it { should validate_presence_of(:player) }

    it 'should validate points attributes for a points consequent' do
      expect(FactoryGirl.build(:rule_consequent_event, :point_consequent, point_type: nil)).to be_invalid
      expect(FactoryGirl.build(:rule_consequent_event, :point_consequent, point_count: nil)).to be_invalid
    end

    it 'should validate achievement attributes for a achievement consequent' do
      expect(FactoryGirl.build(:rule_consequent_event, :achievement_consequent, achievement_id: nil)).to be_invalid
    end
  end

  describe 'associations' do
    it { should belong_to(:player) }
  end

end