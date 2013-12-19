class CommentsController < ApplicationController

  respond_to :html

  before_filter :authenticate_user!, only: [:create]

  def create
    @comment = current_user.comments.new(params[:comment])

    if @comment.save
      flash[:notice] = "Successfully created comment!"
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
    end 
    
    # respond towards the passed location or go back 
    respond_with(@comment, location: params[:location] || request.referer)
  end

end
