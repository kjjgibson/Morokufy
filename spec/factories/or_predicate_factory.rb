FactoryGirl.define do
  factory :or_predicate do
    association :predicate1, factory: :web_hook_predicate
    association :predicate2, factory: :web_hook_predicate
    web_hook_rule
  end
end
