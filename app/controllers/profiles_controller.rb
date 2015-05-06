class ProfilesController < ApplicationController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(profile_params)
      flash.now[:notice] = "Profile successfully updated"
    end

    render :edit 
  end

  private

  def profile_params
    params.require(:profile).permit(:username, :first_name, :last_name, :time_zone, :preferred_reading_hour)
  end
end
