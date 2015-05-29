require 'spec_helper'

describe MembershipReadingsController, type: :controller do

  let(:challenge){create(:challenge, chapters_to_read:'mi 1-4')} 
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}
  let(:membership_reading){ create(:membership_reading, membership: membership)}

  context 'User access through email' do
    context 'with a valid token' do
      before(:each) do
        get :edit,
          id: membership_reading.id,
          user_email: user.email,
          user_token: user.authentication_token
      end

      describe 'GET#edit' do
        it "finds the membership_reading's reading" do
          expect(assigns(:reading)).to eql(membership_reading.reading)
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

  describe 'GET#create' do
    context 'with a valid token' do
      before(:each) do
        get :edit,
          id: membership_reading.id,
          user_email: user.email,
          user_token: user.authentication_token
      end

      it "renders the :edit template" do
        expect(response).to render_template(:edit)
      end

      it "finds the membership_reading's user" do
        expect(assigns(:user)).to eql(membership_reading.membership.user)
      end

      it "finds the membership_reading's reading" do
        expect(assigns(:reading)).to eql(membership_reading.reading)
      end

      it "assigns a comment to be available in the form" do
        expect(assigns(:comment)).to be_truthy
      end
    end

    context "with an invalid token" do
      it "set the flash with an error message" do
        pending
        post :create, id: "blah"
        should set_the_flash
      end
    end
  end
end
