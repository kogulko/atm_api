require 'rails_helper'

RSpec.describe Atm::Replenish do
  let(:invalid_banknote) { banknote_hash(15, 2.5) }
  let(:valid_10_banknote) { banknote_hash(10, 2) }
  let(:another_valid_10_banknote) { banknote_hash(10, 4) }
  let(:valid_5_banknote) { banknote_hash(5, 6) }
  let(:valid_2_banknote) { banknote_hash(2, 3) }
  let(:default_options) { { } }
  let(:default_params) { { banknotes: [] } }
  let(:expected_attrs) { { total_sum: nil } }

  describe 'validation' do
    it 'fails with invalid banknotes' do
      assert_fail described_class, ctx(banknotes: [invalid_banknote]) do |result|
        assert_equal [:face_value, :quantity], result[:log][0].keys
      end
    end

    it 'don`t fails with valid banknotes' do
      assert_pass described_class, ctx(banknotes: [valid_10_banknote]), {} do |result|
        assert_equal valid_10_banknote.values.inject(:*), result[:total_sum]
      end
    end
  end

  it 'increments number of banknotes' do
    expect {
      described_class.(banknotes: [
        valid_10_banknote,
        another_valid_10_banknote,
        valid_5_banknote,
        valid_2_banknote
      ])
    }.to change(Banknote, :total_sum).by(96)
  end
end
