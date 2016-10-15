require 'rails_helper'
require 'hip_chat/card_thumbnail'

describe 'CardThumbnail' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:card_thumbnail)).to be_valid
    end

    it 'should validate the presence of the url' do
      expect(FactoryGirl.build(:card_thumbnail, url: nil)).to be_invalid
    end
  end

end