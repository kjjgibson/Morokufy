require 'rails_helper'
require 'hip_chat/room'

describe 'Room' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:room)).to be_valid
    end
  end

end