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
#
# Indexes
#
#  index_web_hook_predicates_on_web_hook_rule_id  (web_hook_rule_id)
#
# Foreign Keys
#
#  fk_rails_9ae6b82655  (web_hook_rule_id => web_hook_rules.id)
#

class JsonPathPredicate < WebHookPredicate

  validates_presence_of :path

  def evaluate_path(params)
    json_path = JsonPath.new(path)
    return json_path.on(params.to_json)
  end

end
