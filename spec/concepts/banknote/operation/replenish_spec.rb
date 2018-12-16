require 'rails_helper'

RSpec.describe ATM::Replenish do
  let(:invalid_banknote) { { face_value: 15, quantity: 2.5 } }
  let(:valid_10_banknote) { { face_value: 10, quantity: 2 } }
  let(:another_valid_10_banknote) { { face_value: 10, quantity: 4 } }
  let(:valid_5_banknote) { { face_value: 5, quantity: 6 } }
  let(:valid_2_banknote) { { face_value: 2, quantity: 3 } }

  describe 'validation' do
    it 'fails with invalid banknotes' do
      result = described_class.(banknotes: [invalid_banknote])
      expect(result).to be_failure
    end

    it 'don`t fails with valid banknotes' do
      result = described_class.(banknotes: [valid_10_banknote])
      expect(result).to be_success
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
