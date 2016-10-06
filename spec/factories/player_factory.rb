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
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
