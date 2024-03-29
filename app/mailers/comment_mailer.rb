class CommentMailer < ActionMailer::Base
  default from: "Bible Challenges <no-reply@biblechallenges.com>"

  def new_comment_notification(comment)
    @recipient = comment.commentable.user
    @original_comment = comment.commentable
    @newcomment = comment

    mail(
      to: @recipient.email,
      subject: "#{comment.user.name} has responded to your comment"
    )
  end
end
