# == Schema Information
#
# Table name: web_hook_predicates
#
#  id               :integer          not null, primary key
#  web_hook_rule_id :integer
#  key_path         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  actable_id       :integer
#  actable_type     :string
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

  actable
  belongs_to :web_hook_rule

  validates_presence_of :web_hook_rule

  # Return true if this predicate evaluates to true
  # Implementation of this method depends on the subclass
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    raise NotImplementedError
  end

  # Get the value for a json key path
  #
  # === Parameters
  #
  # * +params+ - A hash of params in which to search
  def value_for_key_path(params)
    keys = key_path.split('.')
    value = params
    keys.each do |key|
      value = value[key.to_sym]
      break unless value
    end

    return value
  end

end
