FactoryGirl.define do
  factory :json_path_result_includes_any_predicate do
    path 'key'
    expected_values ['value']
    web_hook_rule
  end
end
