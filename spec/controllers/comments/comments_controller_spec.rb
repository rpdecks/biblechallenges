require 'spec_helper'

describe Comments::CommentsController, "Routing" do
  it { {post: "/comments/1/comments"}.should route_to(controller: "comments/comments",
                                                      action: "create",
                                                      comment_id: "1") }
end

describe Comments::CommentsController, "Actions" do
  context "with an existing comment" do
    let(:user) { create(:user) }
    let(:reading) { create(:reading) }

    before do
      sign_in :user, user

      @challenge = reading.challenge
      @challenge.members << user
      @comment = create(:reading_comment, commentable: reading, user: user)
    end

    describe "on POST to #create" do
      it "creates a new comment" do
        expect {
          post :create, comment_id: @comment.to_param, comment: {content: "Hello"}
        }.to change(Comment, :count).by(1)
      end

      it "redirects back to the comment's reading" do
        post :create, comment_id: @comment.to_param, comment: {content: "Hello"}

        should redirect_to(reading_path(reading))
      end
    end
  end
end
