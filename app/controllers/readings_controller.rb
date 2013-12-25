class ReadingsController < ApplicationController

  before_filter :authenticate_user!, only: [:show]
  respond_to :html

  def show
    @reading = Reading.find_by_id(params[:id])

    if @reading.challenge.members.include? current_user
      @comment = Comment.new
      @comments = @reading.comments.order("created_at desc")
      @last_read_by = @reading.last_read_by  
    else
      @reading = nil
      redirect_to root_url
    end
    
  end
end
