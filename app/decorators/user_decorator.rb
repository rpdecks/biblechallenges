class UserDecorator < Draper::Decorator

  delegate_all

  def initialed_name
    result = ""
    if name
      parts_of_name = name.split
      parts_of_name.each do |name_part|
        # we want the entire first part of the name field
        if name_part == parts_of_name.first
          result += name_part
        else
          result += " #{name_part[0]}."
        end
      end
    end
    result
  end



end
