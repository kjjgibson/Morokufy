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

require 'rails_helper'
require 'shoulda-matchers'

describe Alias, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:alias, :with_player)).to be_valid()
  end

  describe 'validations' do
    it { should validate_presence_of(:alias_type) }
    it { should validate_presence_of(:alias_value) }
  end

  describe 'associations' do
    it { should belong_to(:player) }
  end

end
