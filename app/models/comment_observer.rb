class CommentObserver < ActiveRecord::Observer

  def after_create(comment)
    if comment.commentable.is_a? Comment
      CommentMailer.new_comment_notification(comment).deliver_now
    end
  end

end
