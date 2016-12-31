FactoryGirl.define do
  factory :value_matches_predicate do
    key_path 'key'
    expected_value 'value'
    web_hook_rule
  end
end
