# == Schema Information
#
# Table name: aliases
#
#  id          :integer          not null, primary key
#  alias_type  :string
#  alias_value :string
#  player_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :alias do
    alias_type { Alias::AliasType::NAME }
    alias_value 'agent smith'

    trait :with_player do
      player
    end
  end
end
