class ReadingsController < ApplicationController
  before_filter :authenticate_user!, :set_reading, only: [:show]
  before_filter :set_reading

  def show
    if @reading.challenge.members.include? current_user
      @membership = Membership.includes(:challenge).find_by(user: current_user, challenge: @reading.challenge)
      @verses = @reading.chapter.by_version(current_user.bible_version)
    else
      redirect_to root_url
    end
  end

  def update
    flash[:notice] = 'Reading successfully updated' if @reading.update_attributes(reading_params)
    redirect_to creator_challenge_path(@reading.challenge)
  end

  def edit; end

  private

  def set_reading
    @reading = Reading.includes(:challenge, :chapter).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def reading_params
    params.require(:reading).permit(:chapter_id, :challenge_id, :date, :discussion)
  end
end
