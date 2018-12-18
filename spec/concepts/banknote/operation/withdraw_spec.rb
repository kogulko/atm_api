require 'rails_helper'

RSpec.describe Atm::Withdraw do

  let(:default_params) { { amount: amount } }
  let(:default_options) { { } }


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
          assert_equal('Insufficient Funds', result[:log])
        end
      end
    end
  end
end
