class UserDecorator < Draper::Decorator
  include PrettyDate
  delegate_all
end
