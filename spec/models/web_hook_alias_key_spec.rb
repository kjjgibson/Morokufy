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

require 'rails_helper'
require 'shoulda-matchers'

describe WebHookAliasKey, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook_alias_key)).to be_valid
  end

  describe 'associations' do
    it { should belong_to :web_hook }
  end

  describe 'validations' do
    it { should validate_presence_of :alias_key }
    it { should validate_presence_of :alias_type }
    it { should validate_presence_of :web_hook }
  end

end
