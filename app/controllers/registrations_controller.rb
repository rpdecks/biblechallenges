class RegistrationsController < Devise::RegistrationsController
  def update
    super
  end

  protected

  def after_update_path_for(resource)
    profile_path
  end

end
