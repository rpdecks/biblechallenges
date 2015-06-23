describe "update_daily_statistics" do  
  it "updates the user statistics daily" do
    challenge = create(:challenge, :with_readings, begindate: "2050-01-01")
    create(:membership, user: user_7am_eastern_time, challenge: challenge)
    create(:membership, user: user_7am_pacific_time, challenge: challenge)

    todays_date = Date.parse("2050-01-01")
    DailyEmailScheduler.set_daily_email_jobs2(todays_date)
    a = Time.at(DailyEmailWorker.jobs.second["at"])
    b = Time.at(DailyEmailWorker.jobs.last["at"])
    time_lapse = ( b - a ) / 3600
    expect(time_lapse).to eq 3
  end

  def user_7am_pacific_time
    create(:user, profile: create(:profile, time_zone: "Pacific Time (US & Canada)", preferred_reading_hour: 7))
  end

  def user_7am_eastern_time
    create(:user, profile: create(:profile, time_zone: "Eastern Time (US & Canada)", preferred_reading_hour: 7))
  end
end
