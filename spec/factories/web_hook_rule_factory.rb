# == Schema Information
#
# Table name: web_hook_rules
#
#  id          :integer          not null, primary key
#  name        :string
#  web_hook_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_web_hook_rules_on_web_hook_id  (web_hook_id)
#
# Foreign Keys
#
#  fk_rails_25bdf17518  (web_hook_id => web_hooks.id)
#

FactoryGirl.define do
  factory :web_hook_rule do
    name { Faker::Hipster.word }
    web_hook
  end
end
