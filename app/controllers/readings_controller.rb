class ReadingsController < ApplicationController

  respond_to :html

  def show
    @comment = Comment.new
    @reading = Reading.find(params[:id])
    @comments = @reading.comments.order("created_at desc")
    
  end
end
