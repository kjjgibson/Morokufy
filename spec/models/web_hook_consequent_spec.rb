# == Schema Information
#
# Table name: web_hook_consequents
#
#  id               :integer          not null, primary key
#  web_hook_rule_id :integer
#  event_name       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_web_hook_consequents_on_web_hook_rule_id  (web_hook_rule_id)
#
# Foreign Keys
#
#  fk_rails_c216bce9ea  (web_hook_rule_id => web_hook_rules.id)
#

require 'rails_helper'
require 'shoulda-matchers'

describe WebHookConsequent, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook_consequent)).to be_valid
  end

  describe 'associations' do
    it { should belong_to :web_hook_rule }
  end

  describe 'validations' do
    it { should validate_presence_of :event_name }
    it { should validate_presence_of :web_hook_rule }
  end

end
