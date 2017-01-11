# == Schema Information
#
# Table name: json_path_has_result_predicates
#
#  id :integer          not null, primary key
#

class JsonPathHasResultPredicate < ApplicationRecord

  acts_as :json_path_predicate, as: :jpp_actable, dependent: :destroy

  # Return true if the key in present in the params
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    return evaluate_path(params).count > 0
  end

end
