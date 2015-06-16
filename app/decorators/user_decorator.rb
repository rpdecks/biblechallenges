class UserDecorator < Draper::Decorator
  include PrettyDate
  delegate_all

  def fullname
    "#{first_name} #{last_name}"
  end
end
