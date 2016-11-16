# == Schema Information
#
# Table name: web_hook_predicates
#
#  id               :integer          not null, primary key
#  web_hook_rule_id :integer
#  web_hook_key     :string
#  expected_value   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_web_hook_predicates_on_web_hook_rule_id  (web_hook_rule_id)
#
# Foreign Keys
#
#  fk_rails_9ae6b82655  (web_hook_rule_id => web_hook_rules.id)
#

require 'rails_helper'
require 'shoulda-matchers'

describe WebHookPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook_predicate)).to be_valid
  end

  describe 'associations' do
    it { should belong_to :web_hook_rule }
  end

  describe 'validations' do
    it { should validate_presence_of :web_hook_key }
    it { should validate_presence_of :expected_value }
    it { should validate_presence_of :web_hook_rule }
  end

  describe '#is_true' do
    let(:web_hook_key) { 'result' }
    let(:expected_value) { 'pass' }
    let(:web_hook_predicate) { FactoryGirl.create(:web_hook_predicate, web_hook_key: web_hook_key, expected_value: expected_value) }

    context 'key not found' do
      context 'single level key' do
        let(:web_hook_key) { 'result' }

        it 'should return false' do
          expect(web_hook_predicate.is_true?({})).to eq(false)
        end
      end

      context 'multi level key' do
        let(:web_hook_key) { 'build.result' }

        it 'should return false' do
          expect(web_hook_predicate.is_true?({})).to eq(false)
        end
      end
    end

    context 'key found' do
      context 'single level key' do
        let(:web_hook_key) { 'result' }

        context 'found value matches expected value' do
          it 'should return true' do
            expect(web_hook_predicate.is_true?({ result: 'pass' })).to eq(true)
          end
        end

        context 'found value does not match expected value' do
          it 'should return false' do
            expect(web_hook_predicate.is_true?({ result: 'fail' })).to eq(false)
          end
        end
      end

      context 'multi level key' do
        let(:web_hook_key) { 'build.result' }

        context 'found value matches expected value' do
          it 'should return true' do
            expect(web_hook_predicate.is_true?({ build: { result: 'pass' } })).to eq(true)
          end
        end

        context 'found value does not match expected value' do
          it 'should return false' do
            expect(web_hook_predicate.is_true?({ build: { result: 'fail' } })).to eq(false)
          end
        end
      end
    end
  end

end
