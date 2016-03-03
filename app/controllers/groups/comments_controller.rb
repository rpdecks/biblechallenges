class Groups::CommentsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_group
  before_filter :send_to_profile_if_nameless, only: [:create]

  def create
    if @group.has_member?(current_user)
      @comment = current_user.comments.new(comment_params) 

      if @comment.save
        flash[:notice] = "Successfully created comment!"
        redirect_to params[:location] || request.referer
      else
        flash[:alert] = @comment.errors.full_messages.to_sentence
        redirect_to params[:location] || request.referer
      end
    else
      redirect_to params[:location] || request.referer
    end
  end

  def destroy
    if (@comment = current_user.comments.find_by_id(params[:id]))
      @comment.destroy
      flash[:notice] = "Successfully deleted comment"
      redirect_to member_challenge_path(@group.challenge, anchor: "mygroup")
    else
      redirect_to root_url
    end
  end

  def find_group
    @group = Group.find_by_id(params[:group_id])
  end

  private

  def send_to_profile_if_nameless
    redirect_to edit_user_path if current_user.name.blank?
  end

  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type, :invisible, :flag_count)
  end
end
