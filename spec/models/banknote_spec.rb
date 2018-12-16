require 'rails_helper'

RSpec.describe Banknote, type: :model do
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
