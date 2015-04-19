class ApplicationController < ActionController::Base
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  # Internal: The rescue action for ActionController::UnpermittedParameters.
  #
  # exception - The exception being rescued from.
  def unpermitted_parameters(exception)
    render_errors(exception.message)
  end

  # Internal: The rescue action for ActiveRecord::RecordNotFound
  #
  # exception - The exception being rescued from.
  def not_found
    render_errors('page not found', :not_found)
  end

  # Internal: Helper method for rendering exception messages.
  #
  # error - The error message or hash of error messages.
  # status_code - The HTTP status code or status code symbol (e.g. 404 or :not_found)
  def render_errors(error, status_code = :unprocessable_entity)
    render json: { message: error }, status: status_code
  end

end
