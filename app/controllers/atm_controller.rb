class AtmController < ApplicationController

  def replenish
    result = Atm::Replenish.(replenish_params.to_h)
    if result.success?
      render json: { total_sum: result[:total_sum] }, status: 200
    else
      render json: { errors: result[:log] }, status: 422
    end

  end

  def withdraw
    result = Atm::Withdraw.(withdraw_params.to_h)
    if result.success?
      render json: { banknotes: result[:banknotes] }, status: 200
    else
      render json: { error: result[:log] }, status: 422
    end
  end

  private

  def replenish_params
    params.require(:atm).permit(banknotes: [:face_value, :quantity])
  end

  def withdraw_params
    params.require(:atm).permit(:amount)
  end
end
