class CommentMailer < ActionMailer::Base
  default from: "mailer@biblechallenge.com"

  def new_comment_notification(comment)
    @recipient = comment.commentable.user
    @original_comment = comment.commentable

    mail to: @recipient.email, subject: "New response on your comment"
  end
end
