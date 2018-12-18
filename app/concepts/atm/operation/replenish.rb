require 'dry/validation'

class Atm::Replenish < Trailblazer::Operation
  extend Contract::DSL

  step :model!

  contract :params, ReplenishParamsSchema
  step Contract::Validate( name: :params, key: :banknotes )
  failure :validation_error!, fail_fast: true

  success :add_banknotes!
  success :log_total_sum

  # Steps
  def model!(options)
    options['model'] = Banknote
  end

  # Successes
  def add_banknotes!(options, params:, model:, **)
    params[:banknotes].each do |banknote_params|
      if banknote = model.find_by(face_value: banknote_params[:face_value])
        banknote.increment!(:quantity, banknote_params[:quantity])
      else
        model.create(banknote_params)
      end
    end
  end

  def log_total_sum(options)
    options[:total_sum] = Banknote.total_sum
  end

  # Failures
  def validation_error!(options)
    options[:log] = options['result.contract.params'].errors 
  end
end
