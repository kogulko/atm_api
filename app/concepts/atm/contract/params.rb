require "dry/validation"

ReplenishParamsSchema = Dry::Validation.Schema do
  each do
    schema do
      required(:face_value).value(included_in?: Banknote::AVAILABLE_FACE_VALUES)
      required(:quantity).value(type?: Integer, gt?: 0)
    end
  end
end

WithdrawParamsSchema = Dry::Validation.Schema do
  required(:amount).value(type?: Integer, gt?: 0)
end