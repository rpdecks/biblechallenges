class MembershipForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :email, :bible_version, :user
  validates_presence_of :email


  def initialize(attributes = [])
    attributes.each do |name, value|
      send("#{name}=",value)
    end
  end


  def subscribe
    self.user = User.find_or_initialize_by_email email
  end

  def persisted?
    false
  end

end