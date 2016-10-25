require 'hip_chat/card_activity'

FactoryGirl.define do
  factory :card_activity, class: HipChat::CardActivity do
    skip_create

    html 'html'
    icon
  end
end
