require 'hip_chat/card_thumbnail'

FactoryGirl.define do
  factory :card_thumbnail, class: HipChat::CardThumbnail do
    skip_create

    url 'url'
    width 100
    height 100
    url_retina 'url_retina'
  end
end
