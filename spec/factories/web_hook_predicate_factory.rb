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

FactoryGirl.define do
  factory :web_hook_predicate do
    web_hook_rule
  end
end
