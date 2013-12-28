class Readings::CommentsController < ApplicationController

  respond_to :html

  before_filter :authenticate_user!, only: [:create]

  def create
    @reading = Reading.find_by_id(params[:reading_id])
    @comment = current_user.comments.new(params[:comment])

    if @comment.save
      flash[:notice] = "Successfully created comment!"
      respond_with([@reading,@comment], location: params[:location] || request.referer)
    else
      # more for jose:  the reason this else is here is because
      # the location param to respond_with only overrides the response on 
      # a valid object.  How do you override the respond_with on an invalid object
      # so we can return to the sending form?
      flash[:alert] = @comment.errors.full_messages.to_sentence
      redirect_to params[:location] || request.referer
    end 
  end
end
