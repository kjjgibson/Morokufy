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

class WebHookRule < ApplicationRecord

  belongs_to :web_hook
  has_many :web_hook_predicates
  has_many :web_hook_consequents

  validates_presence_of :name, :web_hook

  # Evaluate the rule by evaluating each of the rules predicates
  # If all predicates are true then we return true, otherwise false
  #
  # === Parameters
  #
  # * +params+ - A hash of params in which to search
  def evaluate(params)
    result = true

    web_hook_predicates.each do |predicate|
      unless predicate.is_true?(params)
        result = false
        #If we've found a predicate that evaluates to false there's no point in continuing
        break
      end
    end

    return result
  end

end
