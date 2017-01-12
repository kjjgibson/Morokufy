FactoryGirl.define do
  factory :json_path_has_result_predicate do
    path 'key'
    web_hook_rule
  end
end
