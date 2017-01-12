FactoryGirl.define do
  factory :json_path_result_includes_all_predicate do
    path 'key'
    expected_values ['value']
    web_hook_rule
  end
end
