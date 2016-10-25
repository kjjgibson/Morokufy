# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :player do
    identifier { Faker::Name.name.downcase.gsub(/\s+/, '') }
    api_key 'api_key'
    shared_secret 'shared_secret'
    aliases { build_list(:alias, aliases_count) }

    transient do
      aliases_count 1
    end

  end
end
