require 'rails_helper'
require 'hip_chat/card_attribute'

describe 'CardAttribute' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:card_attribute)).to be_valid
    end

    it 'should validate the presence of the url' do
      expect(FactoryGirl.build(:card_attribute, value: nil)).to be_invalid
    end
  end

end