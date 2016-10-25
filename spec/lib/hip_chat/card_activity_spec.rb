require 'rails_helper'
require 'hip_chat/card_activity'

describe 'CardActivity' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:card_activity)).to be_valid
    end

    it 'should validate the presence of the url' do
      expect(FactoryGirl.build(:card_activity, html: nil)).to be_invalid
    end
  end

end