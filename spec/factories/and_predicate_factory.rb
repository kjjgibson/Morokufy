FactoryGirl.define do
  factory :and_predicate do
    association :predicate1, factory: :web_hook_predicate
    association :predicate2, factory: :web_hook_predicate
    web_hook_rule
  end
end
