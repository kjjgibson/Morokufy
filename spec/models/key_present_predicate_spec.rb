require 'rails_helper'
require 'shoulda-matchers'

describe KeyPresentPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:key_present_predicate)).to be_valid
  end

  describe '#is_true?' do
    let(:key_path) { 'result' }
    let(:expected_value) { 'pass' }
    let(:key_present_predicate) { FactoryGirl.create(:key_present_predicate, key_path: key_path) }

    context 'key not found' do
      context 'single level key' do
        let(:key_path) { 'result' }

        it 'should return false' do
          expect(key_present_predicate.is_true?(nil, {})).to eq(false)
        end
      end

      context 'multi level key' do
        let(:key_path) { 'build.result' }

        it 'should return false' do
          expect(key_present_predicate.is_true?(nil, {})).to eq(false)
        end
      end
    end

    context 'key found' do
      context 'single level key' do
        let(:key_path) { 'result' }

        it 'should return true' do
          expect(key_present_predicate.is_true?(nil, { result: 'pass' })).to eq(true)
        end
      end

      context 'multi level key' do
        let(:key_path) { 'build.result' }

        it 'should return true' do
          expect(key_present_predicate.is_true?(nil, { build: { result: 'pass' } })).to eq(true)
        end
      end
    end
  end

end
