require 'rails_helper'
require 'hip_chat/card'

describe 'Card' do

  describe 'validations' do
    it 'should have a valid factory' do
      expect(FactoryGirl.build(:card)).to be_valid
    end

    it 'should validate the presence of the style' do
      expect(FactoryGirl.build(:card, style: nil)).to be_invalid
    end

    it 'should validate the presence of the id' do
      expect(FactoryGirl.build(:card, id: nil)).to be_invalid
    end

    it 'should validate the style value' do
      expect(FactoryGirl.build(:card, style: HipChat::Card::Style::FILE)).to be_valid
      expect(FactoryGirl.build(:card, style: HipChat::Card::Style::IMAGE)).to be_valid
      expect(FactoryGirl.build(:card, style: HipChat::Card::Style::APPLICATION)).to be_valid
      expect(FactoryGirl.build(:card, style: HipChat::Card::Style::LINK)).to be_valid
      expect(FactoryGirl.build(:card, style: HipChat::Card::Style::MEDIA)).to be_valid
      expect(FactoryGirl.build(:card, style: 'Jonny Bravc')).to be_invalid
    end

    it 'should validate the format value' do
      expect(FactoryGirl.build(:card, format: HipChat::Card::Format::COMPACT)).to be_valid
      expect(FactoryGirl.build(:card, format: HipChat::Card::Format::MEDIUM)).to be_valid
      expect(FactoryGirl.build(:card, format: 'giraffe')).to be_invalid
    end
  end

end