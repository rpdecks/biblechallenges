require 'spec_helper'

describe MembershipReadingsController, type: :controller do

  let(:challenge){create(:challenge, chapters_to_read:'mi 1-4')} 
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){ create(:membership_reading, membership: membership)}


  describe 'User access' do

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
    end

    describe 'DELETE#destroy' do
      it "deletes a membership_reading" do
        pending  #jim   
        expect { 
          delete :destroy, id: membership_reading.id
        }.to change(MembershipReading, :count).by(-1)
      end
    end
  end


end
