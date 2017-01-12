# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  api_key       :string
#  shared_secret :string
#  identifier    :string
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
