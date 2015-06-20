require 'spec_helper'

describe MembershipReadingsController, type: :controller do

  let(:challenge){create(:challenge, chapters_to_read:'mi 1-4')} 
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){ create(:membership_reading, membership: membership)}

  context 'User access through email' do
    context 'with a valid token' do
      describe 'POST#create' do
        it "finds the membership_reading's reading" do
          reading = create(:reading)
          expect {
            post :create, reading_id: reading.id, membership_id: membership.id, 
              location: confirmation_membership_reading_path(id: reading.id),
              user_email: user.email,
              user_token: user.authentication_token
          }.to change(MembershipReading, :count).by(1)
        end
      end
    end
  end

  context 'User access through website' do
    before do
      sign_in :user, user
      request.env["HTTP_REFERER"] = "where_i_came_from"  #to test redirect back
    end

    describe 'POST#create' do
      it "creates a new membership_reading" do
        reading = create(:reading)
        expect {
          post :create, reading_id: reading.id, membership_id: membership.id
        }.to change(MembershipReading, :count).by(1)
      end
      it "should redirect to :back if params[:location] is not  provided" do
        reading = create(:reading)
        post :create, reading_id: reading.id, membership_id: membership.id
        expect(response).to redirect_to "where_i_came_from"
      end
      it "should redirect to params[:location] if it's provided" do
        reading = create(:reading)
        post :create, reading_id: reading.id, membership_id: membership.id, location: root_path
        should redirect_to(root_path)
      end
      it "should update one of the membership statistics (lamo test)" do 
        challenge = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        user = create(:user)
        membership = challenge.join_new_member(user)

        membership.associate_statistics

        post :create, reading_id: challenge.readings.first.id, membership_id: membership.id

        expect(membership.membership_statistic_progress_percentage.value.to_i).to eq 50

      end
      it "should update the user statistics" do 
        challenge = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        user = create(:user)
        membership = challenge.join_new_member(user)

        user.associate_statistics

        post :create, reading_id: challenge.readings.first.id, membership_id: membership.id

        expect(user.user_statistic_chapters_read_all_time.value).to eq 1
      end
      it "should update the user statistics with multiple memberships" do 
        challenge1 = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        challenge2 = create(:challenge_with_readings, chapters_to_read:'Luke 1-2')
        user = create(:user)
        membership1 = challenge1.join_new_member(user)
        membership2 = challenge2.join_new_member(user)

        user.associate_statistics

        post :create, reading_id: challenge1.readings.first.id, membership_id: membership1.id
        post :create, reading_id: challenge2.readings.first.id, membership_id: membership2.id

        expect(user.user_statistic_chapters_read_all_time.value.to_i).to eq 2
      end
      it "should update the membership statistics" do #todo this should use mocks/spies
        pending
        reading = create(:reading)
        membership.associate_statistics
        MembershipStatistic.descendants.each do |desc|
          desc.name.constantize.stub(:update)
       end

        post :create, reading_id: reading.id, membership_id: membership.id

        MembershipStatistic.descendants.each do |desc|
          expect(desc.name.constantize).to have_received(:update)
        end
        membership.membership_statistics.each do |ms|
          expect(ms).to have_received(:update)
        end
      end
    end

    describe 'DELETE#destroy' do
      it "deletes a membership_reading" do
        mr = create(:membership_reading, membership:membership, reading: create(:reading))
        expect {
          delete :destroy, id: mr.id
        }.to change(MembershipReading, :count).by(-1)
      end
      it "should redirect to :back if params[:location] is not  provided" do
        mr = create(:membership_reading, membership:membership, reading: create(:reading))
        delete :destroy, id: mr.id
        expect(response).to redirect_to "where_i_came_from"
      end
      it "should redirect to params[:location] if it's provided" do
        mr = create(:membership_reading, membership:membership, reading: create(:reading))
        delete :destroy, id: mr.id, location: root_path
        should redirect_to(root_path)
      end
    end
  end
end

=begin
=end
