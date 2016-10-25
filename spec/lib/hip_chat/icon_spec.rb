require 'rails_helper'
require 'hip_chat/icon'

describe 'Icon' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:icon)).to be_valid
    end

    it 'should validate the presence of the url' do
      expect(FactoryGirl.build(:icon, url: nil)).to be_invalid
    end
  end

end