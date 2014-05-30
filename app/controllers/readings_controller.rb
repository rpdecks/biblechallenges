class ReadingsController < ApplicationController

  before_filter :authenticate_user!, only: [:show]
  respond_to :html

  def show
    #for the discussion
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    @reading = Reading.find_by_id(params[:id])
    @discussion_md = markdown.render(@reading.discussion || "")

    if @reading.challenge.members.include? current_user
      @comment = Comment.new
      @comments = @reading.comments.order("created_at desc")
      @last_read_by = @reading.last_read_by  
      @membership = Membership.find_by_user_id_and_challenge_id(current_user.id, @reading.challenge.id)
      @verses = @reading.chapter.verses.by_version(@membership.bible_version)
    else
      @reading = nil
      redirect_to root_url
    end
  end


  def update
    @reading = Reading.find(params[:id])
    flash[:notice] = "Reading successfully updated" if @reading.update_attributes(params[:reading])
    redirect_to reading_path(@reading)
  end


  def edit
    @reading = Reading.find(params[:id])
  end
end
