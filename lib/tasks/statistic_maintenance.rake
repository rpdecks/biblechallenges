namespace :statistic do
  desc "update membership_reading count"

  task fix: :environment do
    all_user_stats = UserStatistic.descendants.map(&:name)

    all_user_stats.each do |stat|
      missing_user_id = UserStatistic.where(type: stat).where(user_id: nil)
      puts "removing:"
      puts stat

      missing_user_id.each do |bad_data|
        bad_data.destroy
        print "."
      end

      puts "Total of #{missing_user_id.size} deleted"
      user_ids = UserStatistic.where(type: stat).pluck(:user_id).uniq
      puts "Destroying duplicated stats"

      user_ids.each do |id|
        user_stats = UserStatistic.where(type: stat).where(user_id: id)
        @record_to_keep = []
        if user_stats.size > 1
          @record_to_keep << user_stats.first
          user_stats.each do |us|
            if us != @record_to_keep.first
              us.destroy
              print "."
            end
          end
        end
      end

    end
  end
end
