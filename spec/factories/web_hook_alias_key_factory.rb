# == Schema Information
#
# Table name: web_hook_alias_keys
#
#  id          :integer          not null, primary key
#  web_hook_id :integer
#  alias_key   :string
#  alias_type  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_web_hook_alias_keys_on_web_hook_id  (web_hook_id)
#
# Foreign Keys
#
#  fk_rails_985bb062db  (web_hook_id => web_hooks.id)
#

FactoryGirl.define do
  factory :web_hook_alias_key do
    alias_key 'name'
    alias_type Alias::AliasType::NAME
    web_hook
  end
end
