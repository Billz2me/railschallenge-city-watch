class RespondersController < ApplicationController
  before_action :permit_parameters!, only: [:create, :update]

  # Public: POST /responders
  def create
    @responder = Responder.new(@permitted_parameters)

    if @responder.valid? && @responder.save
      render @responder, status: :created
    else
      render_exception_message(@responder.errors, :unprocessable_entity)
    end
  end

  # Public: GET /responders/:name
  def show
  end

  # Public: [PUT, PATCH] /responders/:name
  def update
  end

  private

  # Internal: Mass assignment protection by permitting URL parameters.
  #
  # Raises ActionController::UnpermittedParameters.
  # Returns an ActionController::Parameter that acts like a Hash containing the permitted keys.
  def permit_parameters!
    @permitted_parameters = params.require(:responder).permit(:type, :name, :capacity)
  end
end
