# == Schema Information
#
# Table name: json_path_result_matches_predicates
#
#  id              :integer          not null, primary key
#  expected_values :string
#

class JsonPathResultMatchesPredicate < ApplicationRecord

  acts_as :json_path_predicate, as: :jpp_actable, dependent: :destroy

  serialize :expected_values, Array

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
