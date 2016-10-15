require 'hip_chat/icon'

FactoryGirl.define do
  factory :icon, class: HipChat::Icon do
    skip_create

    url 'url'
    url_retina 'url_retina'
  end
end
