require 'hip_chat/card'

FactoryGirl.define do
  factory :card, class: HipChat::Card do
    skip_create

    style { HipChat::Card::Style::FILE }
    format { HipChat::Card::Format::MEDIUM }
    url 'url'
    title 'title'
    description 'description'
    association :thumbnail, factory: :card_thumbnail
    association :activity, factory: :card_activity
    attributes { [FactoryGirl.build(:card_attribute)] }
    id 'id'
    icon
  end
end
