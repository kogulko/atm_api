FactoryBot.define do
  factory :banknote do
    face_value { Banknote::AVAILABLE_FACE_VALUES.sample }
    quantity { rand(1..100) }
  end
end
