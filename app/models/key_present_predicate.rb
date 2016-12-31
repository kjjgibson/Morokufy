# == Schema Information
#
# Table name: key_present_predicates
#
#  id :integer          not null, primary key
#

class KeyPresentPredicate < ApplicationRecord

  acts_as :web_hook_predicate

  # Return true if the key in present in the params
  #
  # === Parameters
  #
  # * +params+ - A hash of params in which to search
  def is_true?(params)
    return value_for_key_path(params).present?
  end

end
