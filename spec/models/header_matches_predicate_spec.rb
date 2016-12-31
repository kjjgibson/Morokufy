require 'rails_helper'
require 'shoulda-matchers'

describe HeaderMatchesPredicate, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:header_matches_predicate)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of :header }
    it { should validate_presence_of :expected_value }
  end

  describe '#is_true?' do
    let(:header) { 'X-Event-Key' }
    let(:expected_value) { 'repo:push' }
    let(:header_matches_predicate) { FactoryGirl.create(:header_matches_predicate, header: header, expected_value: expected_value) }
    let(:request) { double('request') }
    let(:headers) { {} }

    before do
      allow(request).to receive(:headers).and_return(headers)
    end

    context 'header not found' do
      let(:headers) { {} }

      it 'should return false' do
        expect(header_matches_predicate.is_true?(request, nil)).to eq(false)
      end
    end

    context 'header found' do
      context 'found header matches expected value' do
        let(:headers) { { 'X-Event-Key' => expected_value } }

        it 'should return true' do
          expect(header_matches_predicate.is_true?(request, nil)).to eq(true)
        end
      end

      context 'found header does not match expected value' do
        let(:headers) { { 'X-Event-Key' => 'unexpected_value' } }

        it 'should return false' do
          expect(header_matches_predicate.is_true?(request, nil)).to eq(false)
        end
      end
    end
  end

end
