# == Schema Information
#
# Table name: web_hook_predicates
#
#  id               :integer          not null, primary key
#  web_hook_rule_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string
#  header           :string
#  expected_values  :string
#  path             :string
#  predicate1_id    :integer
#  predicate2_id    :integer
#
# Indexes
#
#  index_web_hook_predicates_on_web_hook_rule_id  (web_hook_rule_id)
#
# Foreign Keys
#
#  fk_rails_9ae6b82655  (web_hook_rule_id => web_hook_rules.id)
#

class OrPredicate < WebHookPredicate

  has_one :predicate1, class_name: 'WebHookPredicate', foreign_key: 'predicate1_id'
  has_one :predicate2, class_name: 'WebHookPredicate', foreign_key: 'predicate2_id'

  validates_presence_of :predicate1, :predicate2

  # Return true if either one of the predicates are true
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    return predicate1.is_true?(request, params) || predicate2.is_true?(request, params)
  end

end
