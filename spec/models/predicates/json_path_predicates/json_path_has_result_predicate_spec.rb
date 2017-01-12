require 'rails_helper'
require 'shoulda-matchers'

describe JsonPathHasResultPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:json_path_has_result_predicate)).to be_valid
  end

  describe '#is_true?' do
    let(:path) { 'result' }
    let(:expected_value) { 'pass' }
    let(:json_path_has_result_predicate) { FactoryGirl.create(:json_path_has_result_predicate, path: path) }

    context 'key not found' do
      context 'single level key' do
        let(:path) { 'result' }

        it 'should return false' do
          expect(json_path_has_result_predicate.is_true?(nil, {})).to eq(false)
        end
      end

      context 'multi level key' do
        let(:path) { 'build.result' }

        it 'should return false' do
          expect(json_path_has_result_predicate.is_true?(nil, {})).to eq(false)
        end
      end
    end

    context 'key found' do
      context 'single level key' do
        let(:path) { 'result' }

        it 'should return true' do
          expect(json_path_has_result_predicate.is_true?(nil, { result: 'pass' })).to eq(true)
        end
      end

      context 'multi level key' do
        let(:path) { 'build.result' }

        it 'should return true' do
          expect(json_path_has_result_predicate.is_true?(nil, { build: { result: 'pass' } })).to eq(true)
        end
      end
    end
  end

end
