class ReadingsController < ApplicationController

  before_filter :authenticate_user!, only: [:show]

  def show
    #for the discussion
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    @reading = Reading.find_by_id(params[:id])
#    @next_reading = Reading.find_by_id((params[:id]).to_i + 1)
    @discussion_md = markdown.render(@reading.discussion || "")

    if @reading.challenge.members.include? current_user
      @comment = Comment.new
      @comments = @reading.comments.order("created_at desc")
      @last_read_by = @reading.last_read_by
      @membership = Membership.find_by_user_id_and_challenge_id(current_user.id, @reading.challenge.id)
      @verses = @reading.chapter.by_version(@membership.bible_version)
    else
      @reading = nil
      redirect_to root_url
    end
  end


  def update
    @reading = Reading.find(params[:id])
    flash[:notice] = "Reading successfully updated" if @reading.update_attributes(reading_params)
    redirect_to reading_path(@reading)
  end


  def edit
    @reading = Reading.find(params[:id])
  end

  private

  def reading_params
    params.require(:reading).permit( :chapter_id, :challenge_id, :date, :discussion)
  end
end
