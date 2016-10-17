require 'hip_chat/card_description'

FactoryGirl.define do
  factory :card_description, class: HipChat::CardDescription do
    skip_create

    format { HipChat::CardDescription::ValueFormat::HTML }
    value 'value'
  end
end
