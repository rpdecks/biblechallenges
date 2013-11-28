require 'spec_helper'

describe MembershipReadingsController do

  describe 'GET#log' do

    context 'with a valid hash' do
      let(:challenge){create(:challenge, chapterstoread:'mi 1-4')}
      let(:user){create(:user)}
      let(:membership){challenge.join_new_member(user)}
      let(:membership_reading){membership.membership_readings.first}
      let(:hash){Hashids.new("ReAdInG LoG").encrypt(membership_reading.id)}

      it "finds membership_reading" do
        put :log, hash: hash
        expect(assigns(:membership_reading)).to eql(membership_reading)
      end

      it "changes membership_reading state to 'read'" do
        put :log, hash: hash
        expect(membership_reading.reload.state).to eql('read')
      end

    end

  end

end
