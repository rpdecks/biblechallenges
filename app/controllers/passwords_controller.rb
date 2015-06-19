class PasswordsController < Devise::PasswordsController
  protected

  def new
    self.resource = resource_class.new
  end

  #def after_sending_reset_password_instructions_path_for(resource)
  #  #return your path
  #end
end
