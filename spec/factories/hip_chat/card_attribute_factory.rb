require 'hip_chat/card_attribute'

FactoryGirl.define do
  factory :card_attribute, class: HipChat::CardAttribute do
    skip_create

    association :value, factory: :card_attribute_value
    label 'label'
  end
end
