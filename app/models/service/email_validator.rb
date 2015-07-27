class EmailValidator
  include ActiveModel::Validations
  attr_accessor :email

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i 

  def initialize(email)
    @email = email
  end
end
