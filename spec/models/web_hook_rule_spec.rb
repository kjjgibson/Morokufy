# == Schema Information
#
# Table name: web_hook_rules
#
#  id          :integer          not null, primary key
#  name        :string
#  web_hook_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_web_hook_rules_on_web_hook_id  (web_hook_id)
#
# Foreign Keys
#
#  fk_rails_25bdf17518  (web_hook_id => web_hooks.id)
#

require 'rails_helper'
require 'shoulda-matchers'

describe WebHookRule, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook_rule)).to be_valid
  end

  describe 'associations' do
    it { should belong_to :web_hook }
    it { should have_many :web_hook_predicates }
    it { should have_many :web_hook_consequents }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :web_hook }
  end

end
