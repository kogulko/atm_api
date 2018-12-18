require 'dry/validation'

class Atm::Withdraw < Trailblazer::Operation
  extend Contract::DSL

  contract :params, WithdrawParamsSchema
  step Contract::Validate(name: :params)
  failure :validation_error!, fail_fast: true

  step :check_available_amount!
  step :model!
  failure :insufficient_funds!, fail_fast: true

  step :check_available_banknotes!
  failure :no_banknotes!, fail_fast: true

  step :withdraw_money!
  failure :operation_error!, fail_fast: true

  # Steps
  def check_available_amount!(options, params:, **)
    options[:amount] = params[:amount]
    Banknote.total_sum >= params[:amount]
  end

  def model!(options, amount:, **)
    options[:model] = Banknote.in_stock(amount)
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

  def withdraw_money!(options, model:, banknotes:, **)
    banknotes.each do |face_value, needed_quantity|
      return false unless banknote = model.find_by(face_value: face_value)
      return false unless banknote.update(quantity: banknote.quantity - needed_quantity)
    end
    return true
  end

  # Failures
  def validation_error!(options)
    options[:log] = options['result.contract.params'].errors 
  end

  def insufficient_funds!(options)
    options[:log] = 'Insufficient Funds'
  end

  def no_banknotes!(options, model:, **)
    available_banknotes = Banknote.in_stock.pluck(:face_value)
    options[:log] = 'No banknotes to issue the required amount! Available banknotes: ' + available_banknotes.join(', ')
  end

  def operation_error!(options)
    options[:log] = 'Something went wrong! Try next time'
  end
end