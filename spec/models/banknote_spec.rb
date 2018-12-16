require 'rails_helper'

RSpec.describe Banknote, type: :model do
  describe 'class methods' do
    describe '.total_sum' do
      it 'return 0 when atm is empty' do
        expect(described_class.total_sum).to eq(0)
      end

      it 'calculates total sum correctly' do
        create(:banknote, face_value: 1, quantity: 7)
        create(:banknote, face_value: 2, quantity: 9)
        create(:banknote, face_value: 5, quantity: 13)
        create(:banknote, face_value: 10, quantity: 4)
        create(:banknote, face_value: 25, quantity: 5)
        create(:banknote, face_value: 50, quantity: 6)
        expect(described_class.total_sum).to eq(555)
      end
    end
  end

  context 'validations' do
    let(:invalid_face_value) { ([*-100..100] - described_class::AVAILABLE_FACE_VALUES).sample }
    let(:negative_quantity) { rand(-100...0) }
    let(:fractional_quantity) { rand(100) + rand(0.1) }
    let(:valid_face_value) { described_class::AVAILABLE_FACE_VALUES.sample }
    let(:valid_quantity) { rand(100) }

    context 'with invalid data' do
      subject { build(:banknote) }

      it 'raise error, when invalid face value passed' do
        expect(subject).to receive(:face_value=).with(invalid_face_value).and_raise(RuntimeError).and_return(false)
        subject.face_value = invalid_face_value
      end

      it 'invalidate banknote with invalid quantity' do

      end
    end

    context 'with valid data' do
      it 'validate banknote with invalid quantity' do

      end
    end
  end
end
