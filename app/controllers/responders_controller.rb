class RespondersController < ApplicationController
  before_action :permit_parameters!, only: [:create, :update]

  # Public: GET /responders
  def index
    if params[:show].eql?('capacity')
      render json: { capacity: Responder.capacity_report }
    else
      @responders = Responder.all
    end
  end

  # Public: POST /responders
  def create
    @responder = Responder.new(@permitted_parameters)

    if @responder.save
      render @responder, status: :created
    else
      render_errors @responder.errors
    end
  end

  # Public: GET /responders/:name
  def show
    render Responder.find_by!(name: params[:name])
  end

  # Public: [PUT, PATCH] /responders/:name
  def update
    @responder = Responder.find_by!(name: params[:name])

    if @responder.update_attributes(@permitted_parameters)
      render @responder
    else
      render_errors @responder.errors
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
        params.require(:responder).permit(:type, :name, :capacity)
      when :update
        params.require(:responder).permit(:on_duty)
      end
    end
  end
end
