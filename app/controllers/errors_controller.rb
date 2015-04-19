class ErrorsController < ApplicationController

  # Public: Non-existent route catch all.
  # Routes in config/routes.rb are matched from the top down.
  # This action will catch any unmatched routes and render the not_found response.
  def nonexistent_route
    not_found
  end

end
