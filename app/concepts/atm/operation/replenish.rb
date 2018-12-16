require "dry/validation"

class ATM::Replenish < Trailblazer::Operation
  extend Contract::DSL

  step :model!
  contract :params, ParamsSchema
  step Contract::Validate( name: :params, key: :banknotes )
  step :add_banknotes!

  def model!(options, params:, **)
    options['model'] = Banknote
  end

  def add_banknotes!(options, params:, model:, **)
    params[:banknotes].each do |face_value:, quantity:|
      if banknote = model.find_by(face_value: face_value)
        banknote.increment!(:quantity, quantity)
      else
        model.create(face_value: face_value, quantity: quantity)
      end
    end
  end

#   step Contract::Build( constant: Banknote::Contract::Add )
#   step Contract::Validate
end
