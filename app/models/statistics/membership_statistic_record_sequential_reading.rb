class MembershipStatisticRecordSequentialReading < MembershipStatistic

  def name
    "Record Sequential Reading Count"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    record = 0
    running_count = 0
    self.membership.membership_readings.each do |r|
      if r.state == 'read' && r.punctual == 1
        running_count += 1
      else
        if record < running_count
          record = running_count
        end
        running_count = 0
      end
    end
    record
  end

  def update
    self.value = calculate
    save
  end

end
