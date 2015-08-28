require 'spec_helper'

describe EmailLog, type: :model do
  it "logs email scheduling" do
    user = create(:user)
    challenge = create(:challenge, :with_membership, :with_readings)
    create(:membership, user: user, challenge: challenge)

    expect {
      DailyEmailScheduler.set_daily_email_jobs
    }.to change(EmailLog, :count).by(2)

    last_log = EmailLog.first
    expect(last_log.challenge_id).to eq challenge.id
    expect(last_log.user_id).to eq user.id
    expect(last_log.email).to eq user.email
    expect(last_log.time_zone).to eq user.time_zone
    expect(last_log.preferred_reading_hour).
      to eq user.preferred_reading_hour
  end

  it "logs email delivering" do
    skip
    user = create(:user)
    challenge = create(:challenge, :with_membership, :with_readings)
    create(:membership, user: user, challenge: challenge)

    expect {
      DailyEmailScheduler.set_daily_email_jobs
    }.to change(EmailLog, :count).by(2)
  end
end