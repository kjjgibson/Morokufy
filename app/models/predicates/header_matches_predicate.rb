# == Schema Information
#
# Table name: header_matches_predicates
#
#  id             :integer          not null, primary key
#  header         :string
#  expected_value :string
#

class HeaderMatchesPredicate < ApplicationRecord

  acts_as :web_hook_predicate

  validates_presence_of :header, :expected_value

  # Return true if the HTTP header of the request has the expected value
  #
  # === Parameters
  #
  # * +request+ - The HTTP Request object for the webhook
  # * +params+ - A hash of params in which to search
  def is_true?(request, params)
    return request.headers[header] == expected_value
  end

end
