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

class WebHookPredicate < ApplicationRecord

  belongs_to :web_hook_rule

  validates_presence_of :web_hook_rule, :web_hook_key, :expected_value

end
