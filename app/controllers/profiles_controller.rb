class ProfilesController < ApplicationController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      flash.now[:notice] = "Profile successfully updated"
    end

    render :edit 
  end
end
