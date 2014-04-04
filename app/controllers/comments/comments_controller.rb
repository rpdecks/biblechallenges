class Comments::CommentsController < ApplicationController
  def create
    @existing_comment = Comment.find(params[:comment_id])
    @existing_comment.comments.create!(params[:comment].merge(user_id: current_user.id))

    redirect_to @existing_comment.commentable
  end
end
