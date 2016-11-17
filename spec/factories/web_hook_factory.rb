# == Schema Information
#
# Table name: web_hooks
#
#  id          :integer          not null, primary key
#  name        :string
#  request_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :web_hook do
    name { Faker::App.name }
    source_identifier { SecureRandom.hex }
  end
end
