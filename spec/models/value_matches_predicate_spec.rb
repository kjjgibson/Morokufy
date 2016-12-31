require 'rails_helper'
require 'shoulda-matchers'

describe ValueMatchesPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:value_matches_predicate)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of :expected_value }
  end

  describe '#is_true?' do
    let(:key_path) { 'result' }
    let(:expected_value) { 'pass' }
    let(:value_matches_predicate) { FactoryGirl.create(:value_matches_predicate, key_path: key_path, expected_value: expected_value) }

    context 'key not found' do
      context 'single level key' do
        let(:key_path) { 'result' }

        it 'should return false' do
          expect(value_matches_predicate.is_true?(nil, {})).to eq(false)
        end
      end

      context 'multi level key' do
        let(:key_path) { 'build.result' }

        it 'should return false' do
          expect(value_matches_predicate.is_true?(nil, {})).to eq(false)
        end
      end
    end

    context 'key found' do
      context 'single level key' do
        let(:key_path) { 'result' }

        context 'found value matches expected value' do
          it 'should return true' do
            expect(value_matches_predicate.is_true?(nil, { result: 'pass' })).to eq(true)
          end
        end

        context 'found value does not match expected value' do
          it 'should return false' do
            expect(value_matches_predicate.is_true?(nil, { result: 'fail' })).to eq(false)
          end
        end
      end

      context 'multi level key' do
        let(:key_path) { 'build.result' }

        context 'found value matches expected value' do
          it 'should return true' do
            expect(value_matches_predicate.is_true?(nil, { build: { result: 'pass' } })).to eq(true)
          end
        end

        context 'found value does not match expected value' do
          it 'should return false' do
            expect(value_matches_predicate.is_true?(nil, { build: { result: 'fail' } })).to eq(false)
          end
        end
      end
    end
  end

end
