require 'hip_chat/card_attribute_value'

FactoryGirl.define do
  factory :card_attribute_value, class: HipChat::CardAttributeValue do
    skip_create

    url 'url'
    style { HipChat::CardAttributeValue::Style::LOZENGE }
    label 'label'
    icon
  end
end
