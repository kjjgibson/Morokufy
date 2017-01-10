# == Schema Information
#
# Table name: value_matches_predicates
#
#  id             :integer          not null, primary key
#  expected_value :string
#

class ValueMatchesPredicate < ApplicationRecord

  acts_as :json_path_predicate, as: :jpp_actable, dependent: :destroy

  validates_presence_of :expected_value

  # Return true if the key in the params provided has the expected value
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    return evaluate_path(params) == [expected_value]
  end

end
