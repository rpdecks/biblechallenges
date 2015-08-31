require 'spec_helper'

describe EmailLog, type: :model do
  it "logs email scheduling" do
    user = create(:user, time_zone: "Central Time (US & Canada)")
    challenge = create(:challenge, :with_membership, :with_readings)
    create(:membership, user: user, challenge: challenge)

    expect {
      DailyEmailScheduler.set_daily_email_jobs
    }.to change(EmailLog, :count).by(2)

    log = EmailLog.first
    expect(log.challenge_id).to eq challenge.id
    expect(log.user_id).to eq user.id
    expect(log.email).to eq user.email
    expect(log.time_zone).to eq user.time_zone
    expect(log.preferred_reading_hour).
      to eq user.preferred_reading_hour

    expect(log.schedule_time).to_not be_nil
  end

  it "logs email delivering" do
    user = create(:user)
    challenge = create(:challenge, :with_membership, :with_readings)
    create(:membership, user: user, challenge: challenge)

    readings_ids = challenge.readings.tomorrows_readings.pluck(:id)

    expect {
      DailyEmailWorker.perform_async(readings_ids, user.id)
      DailyEmailWorker.perform_async(readings_ids, challenge.owner.id)
      DailyEmailWorker.drain
    }.to change(EmailLog, :count).by(2)

    log = EmailLog.first
    expect(log.schedule_time).to be_nil
    expect(log.readings).to eq readings_ids
  end
end
