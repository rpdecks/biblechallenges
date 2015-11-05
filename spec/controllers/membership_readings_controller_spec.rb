require 'spec_helper'

describe MembershipReadingsController, type: :controller do

  let(:challenge){create(:challenge_with_readings, :with_membership, chapters_to_read:'mi 1-4')}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){ create(:membership_reading, membership: membership)}

  context 'User access through email' do
    context 'with a valid token' do
      describe 'POST#create' do
        it "finds the membership_reading's reading" do
          reading = challenge.readings.first
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
        reading = challenge.readings.first
        expect {
          post :create, reading_id: reading.id, membership_id: membership.id
        }.to change(MembershipReading, :count).by(1)
      end

      it "creates a new membership_reading allowed only for members of the challenge" do
        user2 = create(:user)
        challenge2 = create(:challenge, chapters_to_read:'John 1-4')
        membership2 = challenge2.join_new_member(user2)
        reading = challenge.readings.first
        expect {
          post :create, reading_id: reading.id, membership_id: membership2
        }.to raise_error('Not allowed')
      end

      it "creates a new membership_reading allowed only for the owner of that membership reading" do
        user2 = user #logged in as user
        membership1 = challenge.memberships.first #belongs to user1
        challenge.join_new_member(user2) #user2 joins challenge
        reading = challenge.readings.first
        expect {
          post :create, reading_id: reading.id, membership_id: membership1
        }.to raise_error('Not allowed')
      end

      it "should redirect to :back if params[:location] is not provided" do
        reading = challenge.readings.first
        post :create, reading_id: reading.id, membership_id: membership.id
        expect(response).to redirect_to "where_i_came_from"
      end

      it "should redirect to params[:location] if it's provided" do
        reading = challenge.readings.first
        post :create, reading_id: reading.id, membership_id: membership.id, location: root_path
        should redirect_to(root_path)
      end

      it "should update one of the membership statistics (lamo test)" do 
        challenge = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        user = create(:user)
        sign_in :user, user
        membership = challenge.join_new_member(user)
        membership.associate_statistics

        # inline method will push all jobs through immediately,
        # as opposed to default that will push jobs to an array
        Sidekiq::Testing.inline! do
          post :create, reading_id: challenge.readings.first.id, membership_id: membership.id
          expect(membership.membership_statistic_progress_percentage.value).to eq 50
        end
      end

      it "updates days_read_in_a_row statistics" do
        challenge = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        user = create(:user)
        sign_in :user, user
        membership = challenge.join_new_member(user)
        membership.associate_statistics

        Sidekiq::Testing.inline! do
          post :create, reading_id: challenge.readings.first.id, membership_id: membership.id
        end

        expect(membership.membership_statistic_record_reading_streak.value).to eq 1
      end

      it "should update the chapters_all_time_read statistics after posting a reading" do
        challenge = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        user = create(:user)
        sign_in :user, user
        membership = challenge.join_new_member(user)

        user.associate_statistics
        Sidekiq::Testing.inline! do
          post :create, reading_id: challenge.readings.first.id, membership_id: membership.id
        end
        expect(user.user_statistic_chapters_read_all_time.value).to eq 1
      end

      it "should update chapter_read_all_time value with multiple memberships" do
        challenge1 = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        challenge2 = create(:challenge_with_readings, chapters_to_read:'Luke 1-2')
        user = create(:user)
        sign_in :user, user
        user.associate_statistics
        membership1 = challenge1.join_new_member(user)
        membership2 = challenge2.join_new_member(user)
        Sidekiq::Testing.inline! do
          post :create, reading_id: challenge1.readings.first.id, membership_id: membership1.id
          post :create, reading_id: challenge2.readings.first.id, membership_id: membership2.id
        end

        expect(user.user_statistic_chapters_read_all_time.value).to eq 2
      end

      it "should update chapters_read_all_time statistics even after leaving challenge" do
        pending
        challenge1 = create(:challenge_with_readings, chapters_to_read:'Mat 1-2')
        challenge2 = create(:challenge_with_readings, chapters_to_read:'Luke 1-2')
        user = create(:user)
        membership1 = challenge1.join_new_member(user)
        user.associate_statistics

        post :create, reading_id: challenge1.readings.first.id, membership_id: membership1.id
        post :create, reading_id: challenge1.readings.second.id, membership_id: membership1.id
        membership1.destroy  # this is not really leaving a challenge

        membership2 = challenge2.join_new_member(user)
        post :create, reading_id: challenge2.readings.first.id, membership_id: membership2.id

        expect(user.user_statistic_chapters_read_all_time.value).to eq 3
      end

      it "should update the membership statistics" do #todo this should use mocks/spies
        pending
        reading = challenge.readings.first
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
        reading = challenge.readings.first
        mr = create(:membership_reading, membership:membership, reading: reading, user_id: user.id)
        expect {
          delete :destroy, id: mr.id
        }.to change(MembershipReading, :count).by(-1)
      end

      it "deletes a membership_reading allowed only by a member of a challenge" do
        reading = challenge.readings.first
        user2 = create(:user)
        challenge2 = create(:challenge, chapters_to_read:'John 1-4')
        membership2 = challenge2.join_new_member(user2)
        mr = create(:membership_reading, membership:membership2, reading: reading, user_id: user2.id)
        expect {
          delete :destroy, id: mr.id
        }.to raise_error
      end

      it "should redirect to :back if params[:location] is not  provided" do
        reading = challenge.readings.first
        mr = create(:membership_reading, membership:membership, reading: reading, user_id: user.id)
        delete :destroy, id: mr.id
        expect(response).to redirect_to "where_i_came_from"
      end

      it "should redirect to params[:location] if it's provided" do
        reading = challenge.readings.first
        mr = create(:membership_reading, membership:membership, reading: reading, user_id: user.id)
        delete :destroy, id: mr.id, location: root_path
        should redirect_to(root_path)
      end
    end

    it "allows deleting of a membership_reading only by the owner of that membership reading" do
      user1 = challenge.owner
      user2 = user #logged in as user
      membership1 = challenge.memberships.first
      membership2 = challenge.join_new_member(user2) #user2 joins challenge
      reading = challenge.readings.first
      mr = create(:membership_reading, membership:membership1, reading: reading)
      expect {
        delete :destroy, id: mr.id, membership_id: membership1
      }.to raise_error('Not allowed')
    end
  end
end
