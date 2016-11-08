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

FactoryGirl.define do
  factory :web_hook_consequent do
    event_name 'RideGiraffe'
    web_hook_rule
  end
end
