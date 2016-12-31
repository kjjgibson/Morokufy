FactoryGirl.define do
  factory :key_present_predicate do
    key_path 'key'
    web_hook_rule
  end
end
