class Comments::CommentsController < ApplicationController
  def create
    @existing_comment = Comment.find(params[:comment_id])
    @existing_comment.comments.create!(comment_params.merge(user_id: current_user.id))

    redirect_to params[:location] || @existing_comment.commentable
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type, :invisible, :flag_count)
  end
end
