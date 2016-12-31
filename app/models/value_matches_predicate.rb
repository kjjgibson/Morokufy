# == Schema Information
#
# Table name: value_matches_predicates
#
#  id             :integer          not null, primary key
#  expected_value :string
#

class ValueMatchesPredicate < ApplicationRecord

  acts_as :web_hook_predicate

  validates_presence_of :expected_value

  # Return true if the key in the params provided has the expected value
  #
  # === Parameters
  #
  # * +params+ - A hash of params in which to search
  def is_true?(params)
    return value_for_key_path(params) == expected_value
  end

end
