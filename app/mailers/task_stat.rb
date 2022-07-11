class TaskStat < ApplicationMailer

	def daily_email_stat(challenges_count,members_count,emails_count,t_errors,s_time,e_time,exec_time)
		@total_challenges = challenges_count
		@total_members = members_count
		@emails_count = emails_count
		@errors = t_errors
		@start_time = s_time
		@end_time = e_time
		@execution_time = exec_time
		@date = Time.current.to_date.strftime("%b %d, %Y")
		@schedule_date = DateTime.current.tomorrow.strftime("%b %d, %Y")
		mail(
			to: ENV['REPORT_EMAILS_TO'],
			subject: "DailyEmailScheduler Report - #{@schedule_date}"
		)
	end
end
