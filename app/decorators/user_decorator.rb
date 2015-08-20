class UserDecorator < Draper::Decorator

  delegate_all

  def initialed_name
    parts_of_name = name.split
    result = ""
    parts_of_name.each do |name_part|
      # we want the entire last part of the name field
      if name_part == parts_of_name.last
        result += name_part
      else
        result += "#{name_part[0]}. "
      end
    end
    result
  end



end
