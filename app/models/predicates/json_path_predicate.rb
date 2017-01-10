# == Schema Information
#
# Table name: json_path_predicates
#
#  id               :integer          not null, primary key
#  path             :string
#  jpp_actable_id   :integer
#  jpp_actable_type :string
#

class JsonPathPredicate < ApplicationRecord

  acts_as :web_hook_predicate, dependent: :destroy
  actable as: :jpp_actable

  validates_presence_of :path

  def evaluate_path(params)
    json_path = JsonPath.new(path)
    return json_path.on(params.to_json)
  end

end
