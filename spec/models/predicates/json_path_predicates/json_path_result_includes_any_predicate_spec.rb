require 'rails_helper'
require 'shoulda-matchers'

describe JsonPathResultIncludesAnyPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:json_path_result_includes_any_predicate)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of :expected_values }
  end

  describe '#is_true?' do
    let(:path) { 'result' }
    let(:expected_values) { ['pass', 'fail'] }
    let(:predicate) { FactoryGirl.create(:json_path_result_includes_any_predicate, path: path, expected_values: expected_values) }

    context 'key not found' do
      context 'single level key' do
        let(:path) { 'result' }

        it 'should return false' do
          expect(predicate.is_true?(nil, {})).to eq(false)
        end
      end

      context 'multi level key' do
        let(:path) { 'build.result' }

        it 'should return false' do
          expect(predicate.is_true?(nil, {})).to eq(false)
        end
      end
    end

    context 'key found' do
      let(:path) { 'build[*].result' }

      context 'found values exactly match the expected values' do
        it 'should return true' do
          expect(predicate.is_true?(nil, { build: [{ result: 'pass' }, { result: 'fail' }] })).to eq(true)
        end
      end

      context 'found values match one of the expected values' do
        it 'should return true' do
          expect(predicate.is_true?(nil, { build: [{ result: 'pass' }] })).to eq(true)
        end
      end

      context 'found values do not match any of the expected values' do
        it 'should return false' do
          expect(predicate.is_true?(nil, { build: { result: 'something_else' } })).to eq(false)
        end
      end
    end
  end

end
