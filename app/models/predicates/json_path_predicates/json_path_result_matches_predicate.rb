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

class JsonPathResultMatchesPredicate < JsonPathPredicate

  validates_presence_of :expected_values

  # Return true if the JSONPath expression result matches exactly the expected value
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    return evaluate_path(params) == expected_values
  end

end
