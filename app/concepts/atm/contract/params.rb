require "dry/validation"

ParamsSchema = Dry::Validation.Schema do
  each do
    schema do
      required(:face_value).value(included_in?: Banknote::AVAILABLE_FACE_VALUES)
      required(:quantity).value(gt?: 0, type?: Integer)
    end
  end
end
