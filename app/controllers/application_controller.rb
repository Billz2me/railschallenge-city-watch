class ApplicationController < ActionController::Base 

  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  # Internal: The rescue action for ActionController::UnpermittedParameters.
  # exception - The exception being rescued from. 
  def unpermitted_parameters(exception)
    render_exception_message(exception.message, :unprocessable_entity)
  end

  # Internal: The rescue action for ActiveRecord::RecordNotFound
  # exception - The exception being rescued from. 
  def record_not_found(exception)
    render_exception_message(exception.message, :not_found)
  end

  # Internal: Helper method for rendering exception messages. 
  # message - The error message
  # status_code - The HTTP status code or status code symbol (e.g. 404 or :not_found)
  def render_exception_message(message, status_code)
    render json: { message: message }, status: status_code
  end

end
