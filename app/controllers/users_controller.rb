class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)

    if @user.save
      redirect_to root_path, notice: "Successfully updated user profile."
    else
      flash[:error] = "User not updated. Please try again."
      render :edit
    end
  end

  private

  def user_params
    accessible = [ :name, :email,
                   :time_zone, :preferred_reading_hour,
                   :avatar ]
    unless params[:user][:password].blank?
      accessible << [ :password, :password_confirmation ]
    end
    params.require(:user).permit(accessible)
  end
end
