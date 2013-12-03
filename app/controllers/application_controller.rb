class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

end
