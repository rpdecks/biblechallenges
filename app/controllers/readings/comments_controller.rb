class Readings::CommentsController < ApplicationController

  respond_to :html

  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_reading
  before_filter :verify_username

  def create
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


  def destroy
    if (@comment = current_user.comments.find_by_id(params[:id]))
      @comment.destroy
      flash[:notice] = "Successfully deleted comment"
      respond_with(@reading)
    else
      redirect_to root_url
    end
  end


  def find_reading
    @reading = Reading.find_by_id(params[:reading_id])
  end

  def verify_username
    if current_user.profile.username.blank?
      flash[:notice] = "You must set a username in your profile before you can post comments"
      redirect_to edit_profile_url
    end
  end

end
