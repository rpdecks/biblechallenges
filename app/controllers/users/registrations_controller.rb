class Users::RegistrationsController < Devise::RegistrationsController
  after_action :complete_user, only: :create

  def complete_user
    UserCompletion.new(@user)
  end
end
