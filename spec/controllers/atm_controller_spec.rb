require 'rails_helper'

RSpec.describe AtmController, type: :controller do

  describe 'POST replenish' do
    context 'with invalid data' do
      let(:params) {
        {
          atm: {
            banknotes: [
              banknote_hash(5, 0)
            ]
          }
        }
      }

      it 'returns error, when invalid data passed' do
        expect{
          post :replenish, params: params, as: :json
        }.to change(Banknote, :total_sum).by(0)
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)).to include('errors')
      end

    end

    context 'with valid data' do
      let(:params) {
        {
          atm: {
            banknotes: [
              banknote_hash(5, 10),
              banknote_hash(2, 15)
            ]
          }
        }
      }

      it 'returns total sum, when valid data passed' do
        expect{
          post :replenish, params: params, as: :json
        }.to change(Banknote, :total_sum).by(80)
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to include('total_sum' => 80)
      end
    end
  end

  describe 'POST withdraw' do
    before do
      create(:banknote, face_value: 50, quantity: 10)
      create(:banknote, face_value: 25, quantity: 10)
      create(:banknote, face_value: 10, quantity: 10)
    end

    context 'with invalid data' do
      let(:params) {
        {
          atm: {
            amount: 10000
          }
        }
      }

      it 'returns error, when invalid data passed' do
        expect{
          post :withdraw, params: params, as: :json
        }.to change(Banknote, :total_sum).by(0)
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)).to include('error')
      end

    end

    context 'with valid data' do
      let(:params) {
        {
          atm: {
            amount: 100
          }
        }
      }

      it 'returns error, when invalid data passed' do
        expect{
          post :withdraw, params: params, as: :json
        }.to change(Banknote, :total_sum).by(-100)
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to include('banknotes')
      end
    end
  end
end

