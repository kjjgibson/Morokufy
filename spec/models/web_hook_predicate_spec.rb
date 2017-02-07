# == Schema Information
#
# Table name: web_hook_predicates
#
#  id               :integer          not null, primary key
#  web_hook_rule_id :integer
#  web_hook_key     :string
#  expected_value   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_web_hook_predicates_on_web_hook_rule_id  (web_hook_rule_id)
#
# Foreign Keys
#
#  fk_rails_9ae6b82655  (web_hook_rule_id => web_hook_rules.id)
#

require 'rails_helper'
require 'shoulda-matchers'

describe WebHookPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook_predicate)).to be_valid
  end

  describe 'associations' do
    it { should belong_to :web_hook_rule }
  end

  describe 'validations' do
    it { should validate_presence_of :web_hook_rule }
  end

  describe '#is_true?' do
    let(:web_hook_predicate) { FactoryGirl.create(:web_hook_predicate) }

    it 'should raise an error' do
      expect do
        web_hook_predicate.is_true?(nil, nil)
      end.to raise_error(NotImplementedError)
    end
  end

end
