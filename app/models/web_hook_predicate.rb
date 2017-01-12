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

  # Return true if the key in the params provided has the expected value
  # The web_gook_key is formatted as a period separated string denoting the hash nesting of the params
  #
  # === Parameters
  #
  # * +params+ - A hash of params in which to search
  def is_true?(params)
    key_paths = web_hook_key.split('.')
    found_value = params
    key_paths.each do |key_path|
      found_value = found_value[key_path.to_sym]
      break unless found_value
    end

    return found_value == expected_value
  end

end
