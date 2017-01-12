require 'rails_helper'
require 'shoulda-matchers'

describe TruePredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:true_predicate)).to be_valid
  end

  describe '#is_true?' do
    let(:predicate) { FactoryGirl.create(:true_predicate) }

    it 'should return true' do
      expect(predicate.is_true?(nil, nil)).to eq(true)
    end
  end

end