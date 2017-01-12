FactoryGirl.define do
  factory :header_matches_predicate do
    header 'header'
    expected_values ['value']
    web_hook_rule
  end
end
