require 'rails_helper'
require 'hip_chat/card_description'

describe 'CardDescription' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:card_description)).to be_valid
    end

    it 'should validate the presence of the value' do
      expect(FactoryGirl.build(:card_description, value: nil)).to be_invalid
    end

    it 'should validate the presence of the format' do
      expect(FactoryGirl.build(:card_description, format: nil)).to be_invalid
    end
  end

end