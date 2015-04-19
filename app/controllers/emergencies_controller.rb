class EmergenciesController < ApplicationController
  before_action :permit_parameters!, only: [:create, :update]

  # Public: GET /emergencies
  def index
    render json: { emergencies: Emergency.all }
  end

  # Public: POST /emergencies
  def create
    @emergency = Emergency.new(@permitted_parameters)

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

  # Public: [PUT, PATCH] /emergencies/:code
  def update
    @emergency = Emergency.find(params[:code])

    if @emergency.update_attributes(@permitted_parameters)
      render @emergency
    else
      render_exception_message(@emergency.errors, :unprocessable_entity)
    end
  end

  private

  # Internal: Mass assignment protection by permitting URL parameters.
  #
  # Raises ActionController::UnpermittedParameters.
  # Returns an ActionController::Parameter that acts like a Hash containing the permitted keys.
  def permit_parameters!
    @permitted_parameters ||= begin
      case action_name.to_sym
      when :create
        params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
      else
        params.require(:emergency).permit(:resolved_at, :fire_severity, :police_severity, :medical_severity)
      end
    end
  end
end
