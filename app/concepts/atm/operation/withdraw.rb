require 'dry/validation'

class Atm::Withdraw < Trailblazer::Operation
  extend Contract::DSL


  contract :params, (Dry::Validation.Schema do
    required(:amount).value(type?: Integer, gt?: 0)
  end)
  step Contract::Validate(name: :params)
  failure ->(options, **) { options[:log] = options['result.contract.params'].errors }, fail_fast: true

  step :check_available_amount!
  step :model!

  failure ->(options, **) { options[:log] = 'Insufficient Funds' }, fail_fast: true
  step :check_available_banknotes!
  failure :no_banknotes!, fail_fast: true


  def model!(options, amount:, **)
    options[:model] = Banknote.in_stock(amount)
  end

  def check_available_amount!(options, params:, **)
    options[:amount] = params[:amount]
    Banknote.total_sum >= params[:amount]
  end

  def check_available_banknotes!(options, model:, amount:, **)
    current_amount = amount
    model.pluck(:face_value, :quantity).each_with_object({}) do |(face_value, quantity), hash|
      needed_quantity = current_amount / face_value.to_i
      next if needed_quantity.zero?
      hash[face_value] = [needed_quantity, quantity].min
      current_amount -= hash[face_value] * face_value.to_i
      return options[:banknotes] = hash if current_amount.zero?
    end
    return false
  end


  def no_banknotes!(options, available_banknotes:, **)
    available_banknotes = model.pluck(:face_value)
    options[:log] = 'No banknotes to issue the required amount! Available banknotes: ' + available_banknotes.join(' ,')
  end
end

