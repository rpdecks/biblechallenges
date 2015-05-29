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
    end

    describe 'POST#create' do
      it "creates a new membership_reading" do
        reading = create(:reading)
        expect {
          post :create, reading_id: reading.id, membership_id: membership.id
        }.to change(MembershipReading, :count).by(1)
      end
    end

    describe 'DELETE#destroy' do
      it "deletes a membership_reading" do
        reading = create(:reading)
        mr = create(:membership_reading, membership:membership, reading:reading)
        expect {
          delete :destroy, id: mr.id
        }.to change(MembershipReading, :count).by(-1)
      end
    end
  end
end
