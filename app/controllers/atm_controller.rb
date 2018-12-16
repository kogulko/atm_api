class AtmController < ApplicationController

  def replenish
    result = Atm::Replenish.(replenish_params.to_h)
    if result.success?
      render json: { success:  'sucess' }, status: 200
    else
      render json: { errors: result['result.contract.params'].errors }, status: 422
    end

  end

  def withdraw

  end

  private

  def replenish_params
    params.require(:atm).permit(banknotes: [:face_value, :quantity])
  end
end
