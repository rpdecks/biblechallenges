class ApplicationController < ActionController::Base
  protect_from_forgery

  # todo this should not be possible from all controllers
  acts_as_token_authentication_handler_for User

  def render_nothing(status = :ok)
    render json: {}, status: status
  end



end
