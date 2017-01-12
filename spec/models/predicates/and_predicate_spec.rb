require 'rails_helper'
require 'shoulda-matchers'

describe AndPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:and_predicate)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:predicate1) }
    it { should validate_presence_of(:predicate2) }
  end

  describe 'associations' do
    it { should have_one(:predicate1).class_name('WebHookPredicate').with_foreign_key('predicate1_id') }
    it { should have_one(:predicate2).class_name('WebHookPredicate').with_foreign_key('predicate2_id') }
  end

  describe '#is_true?' do
    let(:predicate) { FactoryGirl.create(:and_predicate, predicate1: predicate1, predicate2: predicate2) }
    let(:predicate1) { FactoryGirl.create(:json_path_has_result_predicate, path: 'cool') }
    let(:predicate2) { FactoryGirl.create(:json_path_has_result_predicate, path: 'awesome') }

    context 'neither predicate is true' do
      it 'should return false' do
        expect(predicate.is_true?(nil, { some_other_path: 'value' })).to eq(false)
      end
    end

    context 'one predicate is true' do
      it 'should return false' do
        expect(predicate.is_true?(nil, { cool: 'value' })).to eq(false)
        expect(predicate.is_true?(nil, { awesome: 'value' })).to eq(false)
      end
    end

    context 'both predicates are true' do
      it 'should return true' do
        expect(predicate.is_true?(nil, { cool: 'value', awesome: 'value' })).to eq(true)
      end
    end
  end

end