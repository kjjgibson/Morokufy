require 'rails_helper'
require 'shoulda-matchers'

describe JsonPathPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:json_path_predicate)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:path) }
  end

  describe '#evaluate_path' do
    let(:path) { 'result' }
    let(:json_path_predicate) { FactoryGirl.create(:json_path_predicate, path: path) }

    context 'key not found' do
      context 'single level key' do
        let(:path) { 'result' }

        it 'should return false' do
          expect(json_path_predicate.evaluate_path({})).to eq([])
        end
      end

      context 'multi level key' do
        let(:path) { 'build.result' }

        it 'should return false' do
          expect(json_path_predicate.evaluate_path({})).to eq([])
        end
      end
    end

    context 'key found' do
      context 'single level key' do
        let(:path) { 'result' }

        it 'should return the value' do
          expect(json_path_predicate.evaluate_path({ result: 'pass' })).to eq(['pass'])
        end
      end

      context 'multi level key' do
        let(:path) { 'build.result' }

        it 'should return the value' do
          expect(json_path_predicate.evaluate_path({ build: { result: 'pass' } })).to eq(['pass'])
        end
      end
    end
  end

end