class MembershipForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :email, :bible_version, :user, :challenge
  validates_presence_of :email, :challenge


  def initialize(attributes = [])
    attributes.each do |name, value|
      send("#{name}=",value)
    end
  end

  def subscribe
    self.user = User.find_or_initialize_by_email email
    if user.new_record?
      generated_password = Devise.friendly_token.first(8)
      self.user.password = generated_password
      self.user.password_confirmation = generated_password
      user.save!
      membership = Membership.new(user: user, bible_version: bible_version, challenge: challenge)
      membership.auto_created_user = true
      membership.save!
    else
      if challenge.membership_for(user).nil?
        challenge.memberships.create({user: user, bible_version: bible_version})
      else
        errors.add(:email, "already registered in this challenge")
        false
      end
    end
  end

  def persisted?
    false
  end

end