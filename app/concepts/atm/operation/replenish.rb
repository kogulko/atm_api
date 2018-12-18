require 'dry/validation'

class Atm::Replenish < Trailblazer::Operation
  extend Contract::DSL

  step :model!

  contract :params, ParamsSchema
  step Contract::Validate( name: :params, key: :banknotes )
  failure ->(options, **) { options[:log] = options['result.contract.params'].errors }, fail_fast: true

  success :add_banknotes!
  success ->(options, **) { options[:total_sum] = Banknote.total_sum }

  def model!(options)
    options['model'] = Banknote
  end

  def log_error!(options)
    options[:log] = options['result.contract.params'].errors
  end

  def add_banknotes!(options, params:, model:, **)
    params[:banknotes].each do |banknote_params|
      if banknote = model.find_by(face_value: banknote_params[:face_value])
        banknote.increment!(:quantity, banknote_params[:quantity])
      else
        model.create(banknote_params)
      end
    end
  end
end
