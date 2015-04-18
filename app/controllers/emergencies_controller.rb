class EmergenciesController < ApplicationController

  before_filter :permit_parameters

  # Public: POST /emergencies
  def create
    @emergency = Emergency.new(@permitted_parameters)

    if @emergency.valid? && @emergency.save
      render @emergency, status: :created
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  private

  def permit_parameters
    @permitted_parameters = params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  rescue ActionController::UnpermittedParameters => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

end
