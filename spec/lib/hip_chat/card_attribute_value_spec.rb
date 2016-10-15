require 'rails_helper'
require 'hip_chat/card_attribute_value'

describe 'CardAttributeValue' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:card_attribute_value)).to be_valid
    end

    it 'should validate the presence of the url' do
      expect(FactoryGirl.build(:card_attribute_value, label: nil)).to be_invalid
    end
  end

end