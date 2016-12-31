# == Schema Information
#
# Table name: web_hook_rules
#
#  id          :integer          not null, primary key
#  name        :string
#  web_hook_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_web_hook_rules_on_web_hook_id  (web_hook_id)
#
# Foreign Keys
#
#  fk_rails_25bdf17518  (web_hook_id => web_hooks.id)
#

require 'rails_helper'
require 'shoulda-matchers'

describe WebHookRule, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:web_hook_rule)).to be_valid
  end

  describe 'associations' do
    it { should belong_to :web_hook }
    it { should have_many :web_hook_predicates }
    it { should have_many :web_hook_consequents }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :web_hook }
  end

  describe '#evaluate' do
    let(:web_hook_rule) { FactoryGirl.create(:web_hook_rule, web_hook_predicates: web_hook_predicates) }
    let(:request) { double('request') }

    context 'no predicates' do
      let(:web_hook_predicates) { [] }

      it 'should return true' do
        expect(web_hook_rule.evaluate(request, {})).to eq(true)
      end
    end

    context 'single predicate' do
      let(:predicate) { FactoryGirl.create(:web_hook_predicate) }
      let(:web_hook_predicates) { [predicate] }

      context 'predicate is false' do
        before do
          allow(predicate).to receive(:specific).and_return(predicate)
          allow(predicate).to receive(:is_true?).and_return(false)
        end

        it 'should return false' do
          expect(web_hook_rule.evaluate(request, {})).to eq(false)
        end
      end

      context 'predicate is true' do
        before do
          allow(predicate).to receive(:specific).and_return(predicate)
          allow(predicate).to receive(:is_true?).and_return(true)
        end

        it 'should return true' do
          expect(web_hook_rule.evaluate(request, {})).to eq(true)
        end
      end
    end

    context 'multiple predicates' do
      let(:predicate1) { FactoryGirl.create(:web_hook_predicate) }
      let(:predicate2) { FactoryGirl.create(:web_hook_predicate) }
      let(:web_hook_predicates) { [predicate1, predicate2] }

      context 'one predicate is false' do
        before do
          allow(predicate1).to receive(:specific).and_return(predicate1)
          allow(predicate2).to receive(:specific).and_return(predicate2)
          allow(predicate1).to receive(:is_true?).and_return(false)
          allow(predicate2).to receive(:is_true?).and_return(true)
        end

        it 'should return false' do
          expect(web_hook_rule.evaluate(request, {})).to eq(false)
        end
      end

      context 'all predicates are true' do
        before do
          allow(predicate1).to receive(:specific).and_return(predicate1)
          allow(predicate2).to receive(:specific).and_return(predicate2)
          allow(predicate1).to receive(:is_true?).and_return(true)
          allow(predicate2).to receive(:is_true?).and_return(true)
        end

        it 'should return true' do
          expect(web_hook_rule.evaluate(request, {})).to eq(true)
        end
      end
    end
  end

end
