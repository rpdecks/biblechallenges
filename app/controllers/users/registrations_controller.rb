class Users::RegistrationsController < Devise::RegistrationsController
  after_action :complete_user, only: :create

  private

  def complete_user
    UserCompletion.new(@user)
  end
end
