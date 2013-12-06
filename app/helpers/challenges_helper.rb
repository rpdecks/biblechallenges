module ChallengesHelper

	def reading_row_class membership_reading
		if membership_reading.state == 'read'
			'success'
		elsif membership_reading.state == 'unread' && membership_reading.reading.date < Date.today
			'danger'
		elsif membership_reading.reading.date == Date.today
			'warning'
		end
	end

end
