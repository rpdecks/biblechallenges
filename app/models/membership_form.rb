class MembershipForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :email
  validates_presence_of :email


  def initialize(attributes = [])
    attributes.each do |name, value|
      send("#{name}=",value)
    end
  end

  def persisted?
    false
  end

end