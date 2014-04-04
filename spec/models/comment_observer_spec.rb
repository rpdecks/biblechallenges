require 'spec_helper'

describe CommentObserver do
  it "sends an e-mail after a comment has been created on another comment" do
    user = create(:user)
    reading = create(:reading)
    reading.challenge.members << user
    comment = create(:reading_comment, commentable: reading, user: user)
    new_comment = comment.comments.create(content: "Hello World")

    expect {
      CommentObserver.instance.after_create(new_comment) # because observers are turned off by default on tests and I believe it's a best practice.
    }.to change(ActionMailer::Base.deliveries, :length).by(1) # Initially. I know we shouldn't send e-mail if the owner is the commentor.
  end
end
