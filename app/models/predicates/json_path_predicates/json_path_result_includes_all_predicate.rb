# == Schema Information
#
# Table name: json_path_result_includes_all_predicates
#
#  id              :integer          not null, primary key
#  expected_values :string
#

class JsonPathResultIncludesAllPredicate < ApplicationRecord

  acts_as :json_path_predicate, as: :jpp_actable, dependent: :destroy

  serialize :expected_values, Array

  validates_presence_of :expected_values

  # Return true if the JSONPath expression result includes all the expected values
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    return (expected_values - evaluate_path(params)).empty?
  end

end
