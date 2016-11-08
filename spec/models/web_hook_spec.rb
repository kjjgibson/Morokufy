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

require 'rails_helper'
require 'shoulda-matchers'

describe WebHook, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook)).to be_valid
  end

  describe 'associations' do
    it { should have_many :web_hook_rules }
    it { should have_many :web_hook_alias_keys }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :request_url }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :request_url }
  end

end
