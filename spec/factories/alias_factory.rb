FactoryGirl.define do
  factory :alias do
    alias_type { Alias::AliasType::NAME }
    alias_value 'agent smith'

    trait :with_player do
      player
    end
  end
end
