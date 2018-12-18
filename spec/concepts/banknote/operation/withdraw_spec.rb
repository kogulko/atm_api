require 'rails_helper'

RSpec.describe Atm::Withdraw do

  let(:default_params) { { amount: amount } }
  let(:default_options) { { } }
  let(:expected_attrs) { { banknotes: {} } }

  context 'failed' do
    context 'with valid amount' do
      let(:amount) { -100 }
      it 'fails with invalid amount' do
        assert_fail described_class, ctx(default_params) do |result|
          assert_equal({ amount: ['must be greater than 0'] }, result[:log])
        end
      end
    end

    context 'with valid amount' do
      let(:amount) { 100 }
      it 'fails with insufficient funds' do
        assert_fail described_class, ctx(default_params) do |result|
          assert_equal 'Insufficient Funds', result[:log]
        end
      end
    end

    context 'without needed banknotes' do
      before do
        create(:banknote, face_value: 50, quantity: 10)
        create(:banknote, face_value: 25, quantity: 10)
        create(:banknote, face_value: 10, quantity: 10)
      end

      let(:amount) { 133 }
      it 'fails with not found banknotes' do
        assert_fail described_class, ctx(default_params) do |result|
          assert_match 'No banknotes to issue', result[:log]
        end
      end
    end

    context 'with system error' do
      before do
        create(:banknote, face_value: 50, quantity: 10)
        expect_any_instance_of(Banknote).to receive(:update).and_return(false)
      end

      let(:amount) { 50 }
      it 'fails at the disbursement stage' do
        assert_fail described_class, ctx(default_params) do |result|
          assert_equal 'Something went wrong! Try next time', result[:log]
        end
      end
    end
  end

  context 'passed' do
    before do
      create(:banknote, face_value: 50, quantity: 10)
      create(:banknote, face_value: 25, quantity: 10)
      create(:banknote, face_value: 10, quantity: 10)
    end

    let(:amount) { 135 }

    it 'gives money' do
      expect {
        assert_pass described_class, ctx(amount: amount), {} do |result|
          assert_equal({ '50' => 2, '25' => 1, '10' => 1 }, result[:banknotes])
        end
      }.to change(Banknote, :total_sum).by(-amount)
    end
  end
end