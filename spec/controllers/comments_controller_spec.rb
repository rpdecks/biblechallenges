require 'spec_helper'

describe CommentsController, "Actions" do
  describe "Guest Posting" do
    describe "POST #create" do
      it "should redirect to login page" do
        post :create, comment: attributes_for(:reading_comment)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe "POST #create" do
    let(:current_user) {create(:user)}
    let!(:membership) {create(:membership, user: current_user, challenge: challenge)}

    before do
      sign_in :user, current_user
    end


    it "should create a new comment"
    it "should redirect to / "
    it "should set the flash"
    it "should redirect to params[:location] if it is provided"
  end

end
