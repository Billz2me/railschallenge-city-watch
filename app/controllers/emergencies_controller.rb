class EmergenciesController < ApplicationController

  # Public: POST /emergencies
  def create
    @emergency = Emergency.new(permitted_parameters)

    if @emergency.valid? && @emergency.save
      render @emergency, status: :created
    else
      render_exception_message(@emergency.errors, :unprocessable_entity)
    end
  end

  # Public: GET /emergencies/:code  
  def show
    render Emergency.find(params[:code])
  end

  private

  # Internal: Mass assignment protection by permitting URL parameters. 
  #
  # Raises ActionController::UnpermittedParameters.
  # Returns an ActionController::Parameter that acts like a Hash containing the permitted keys. 
  def permitted_parameters
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

end
