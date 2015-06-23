class DailyStatisticsUpdater
  def update_daily_statistics(user, time)
    DailyStatisticsWorker.perform_at(time_for_update, member.id)
  end
end
