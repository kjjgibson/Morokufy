# == Schema Information
#
# Table name: key_present_predicates
#
#  id :integer          not null, primary key
#

class KeyPresentPredicate < ApplicationRecord

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
