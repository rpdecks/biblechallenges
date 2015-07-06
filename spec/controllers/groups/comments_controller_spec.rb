require 'spec_helper'

describe Groups::CommentsController, "Actions" do
  describe "Guest Posting" do
    describe "POST #create" do
      it "redirects to login page" do
        post :create, group_id: 1, comment: attributes_for(:group_comment)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe "Delete #delete" do

    let(:current_user) { create(:user) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"  #to test redirect back
    end

    it "should destroy the current comment if the current_user owns it" do
      sign_in :user, current_user
      challenge = create(:challenge_with_readings)
      group = create(:group, challenge: challenge, user: create(:user))
      comment = create(:group_comment, user: current_user, commentable: group) #comment in a group
      expect{ delete :destroy, group_id: group.id, id: comment.id}.to change(Comment, :count).by(-1)
    end

    it "should not destroy the comment if the current_user does not own it" do
      challenge = create(:challenge_with_readings)
      group = create(:group, challenge: challenge, user: create(:user))
      create(:membership, user: current_user, challenge: challenge, group: group)
      comment = create(:group_comment, user: current_user, commentable: group) #comment on a reading
      randomuser = create(:user)
      sign_in :user, randomuser
      expect{ delete :destroy, group_id: group.id, id: comment.id}.not_to change(Comment, :count)
    end

    it "should redirect to login if the user is not logged in" do
      challenge = create(:challenge_with_readings)
      group = create(:group, challenge: challenge, user: create(:user))
      create(:membership, user: current_user, challenge: challenge, group: group)
      comment = create(:group_comment, user: current_user, commentable: group) 
      delete :destroy, group_id: group.id, id: comment.id
      expect(response).to redirect_to new_user_session_url
    end


  end



  describe "POST #create" do
    let!(:current_user) {create(:user)}
    let(:challenge) { create(:challenge_with_readings) }
    let!(:group) {create(:group, challenge: challenge, user: create(:user))}
    let!(:membership) {create(:membership, user: current_user, challenge: challenge, group: group)}
    let(:newcomment_attr) {attributes_for(:group_comment, user: current_user, commentable: group)}
    let!(:existing_comment) {create(:group_comment, user: current_user, commentable: group)}

    before do
      sign_in :user, current_user
      request.env["HTTP_REFERER"] = "where_i_came_from"  #to test redirect back
    end

    it "redirects to the user's profile if the user does not have a username" do
      pending
      current_user.username = nil
      current_user.save
      post :create, group_id: group.id, comment: newcomment_attr
      expect(response).to redirect_to edit_user_registration_url
    end

    it "creates a new group comment" do
      current_user.username = "Phil"
      current_user.save
      expect{post :create, group_id: group.id, comment: newcomment_attr
      }.to change(Comment, :count).by(1)

    end
    it "should redirect to :back if not params[:location] is not  provided" do
      current_user.username = "Phil"
      current_user.save
      post :create, group_id: group.id, comment: newcomment_attr
      expect(response).to redirect_to "where_i_came_from"
    end

    it "should redirect to params[:location] if it's provided" do
      current_user.username = "Phil"
      current_user.save
      post :create, group_id: group.id, comment: newcomment_attr, location: new_user_session_path
      should redirect_to(new_user_session_path)
    end

    it "should redirect to params[:location] if the comment is invalid" do
      current_user.username = "Phil"
      current_user.save
      newcomment_attr[:content] = nil
      post :create, group_id: group.id, comment: newcomment_attr, location: new_user_session_path
      should redirect_to(new_user_session_path)
    end

    it "should set the flash" do
      post :create, group_id: group.id, comment: newcomment_attr
      should set_flash
    end

    it "does not allow a user to create a comment for a group he is not part of " do
      randomuser = FactoryGirl.create(:user)
      sign_out current_user
      sign_in :user, randomuser
      expect{
        post :create, group_id: group.id, comment: attributes_for(:group_comment, commentable_type: "Group", commentable_id: group.id), location: member_challenge_path(group.challenge, anchor: "groups")
      }.to change(Comment, :count).by(0)
    end



  end
end
