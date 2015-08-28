require 'spec_helper'

describe EmailLog, type: :model do
  it "logs email scheduling" do
    user = create(:user)
    challenge = create(:challenge, :with_membership, :with_readings)
    create(:membership, user: user, challenge: challenge)

    expect {
      DailyEmailScheduler.set_daily_email_jobs
    }.to change(EmailLog, :count).by(2)
  end

  it "logs email delivering" do

  end
end
