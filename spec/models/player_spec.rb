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

require 'rails_helper'
require 'shoulda-matchers'

describe Player, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:player)).to be_valid()
  end

  describe 'validations' do
    it { should validate_presence_of(:identifier) }
  end

  describe 'associations' do
    it { should have_many(:aliases) }
  end

end
