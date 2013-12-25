require 'spec_helper'

describe CommentsController, "Actions" do
  let(:challenge) {create(:challenge)}
  describe "Guest Posting" do
    describe "POST #create" do
      it "redirects to login page" do
        post :create, comment: attributes_for(:reading_comment)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe "POST #create" do
    let!(:current_user) {create(:user)}
    let!(:membership) {create(:membership, user: current_user, challenge: challenge)}
    let(:reading) { membership.readings.first}
    let(:newcomment_attr) {attributes_for(:reading_comment, user: current_user, commentable: membership.readings.first)}
    let!(:existing_comment) {create(:reading_comment, user: current_user, commentable: membership.readings.first)}


    before do
      sign_in :user, current_user
      request.env["HTTP_REFERER"] = "where_i_came_from"  #to test redirect back
    end

    it "creates a new reading comment" do
      expect{post :create, comment: newcomment_attr
      }.to change(Comment, :count).by(1)

    end
    it "should redirect to :back if not params[:location] is not  provided" do
      post :create, comment: newcomment_attr
      expect(response).to redirect_to "where_i_came_from"
    end

    it "should redirect to params[:location] if it's provided" do
      post :create, comment: newcomment_attr, location: new_user_session_path
      should redirect_to(new_user_session_path)
    end

    it "should redirect to params[:location] if the comment is invalid" do
      post :create, comment: build(:reading_comment, content: nil), location: new_user_session_path
      should redirect_to(new_user_session_path)
    end

    it "should set the flash" do
      post :create, comment: newcomment_attr
      should set_the_flash
    end

    it "does not allow a user to create a comment for a reading he is not part of (through a challenge)" do
      randomuser = FactoryGirl.create(:user)
      sign_out current_user
      sign_in :user, randomuser
      expect{
        post :create, comment: attributes_for(:reading_comment, commentable_type: "Reading", commentable_id: reading.id), location: reading_path(reading.id)
      }.to_not change(Comment, :count).by(1)
    end



  end
end
