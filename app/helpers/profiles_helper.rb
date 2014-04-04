module ProfilesHelper
  def number_to_hour_of_day(integer)
    ("%02d:00" % integer)
  end
end
