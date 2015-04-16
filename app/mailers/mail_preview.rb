require 'securerandom'

if Rails.env.development?
  class MailPreview < MailView

    def daily_reading_email
      user = User.create(
        email:        Faker::Internet.email,
        password: 'somepassword',
        password_confirmation: 'somepassword'
      )

      challenge = Challenge.create(
                                name: Faker::Company.name,
                                begindate: Time.now,
                                owner_id: 1, #to pass validations
                                chapters_to_read: "Matt 1-5")

      membership = Membership.create(challenge: challenge, user: user)
      membership_reading = membership.membership_readings.first
      MembershipReadingMailer.daily_reading_email(membership_reading)
    end


    def comment_email
      user2 = User.create(
        email:        Faker::Internet.email,
        password: 'somepassword',
        password_confirmation: 'somepassword'
      )
      user = User.create(
        email:        Faker::Internet.email,
        password: 'somepassword',
        password_confirmation: 'somepassword'
      )
      user.profile.username = Faker::Internet.user_name
      user.profile.save
      user2.profile.username = Faker::Internet.user_name
      user2.profile.save

      challenge = Challenge.create(
                                name: Faker::Company.name,
                                begindate: Time.now,
                                owner_id: 1, #to pass validations
                                chapters_to_read: "Matt 1-5")

      membership1 = Membership.create(challenge: challenge, user: user)
#      membership2 = Membership.create(challenge: challenge, user: user2)
      membership_reading = membership1.membership_readings.first
      originalcomment = Comment.create(commentable_id: membership_reading.id, 
                                       content: "Awesome", user_id: user.id,
                                       commentable_type: "Reading")
      nestedcomment = Comment.create(commentable_id: originalcomment.id, 
                                       content: "This is even more Awesome", user_id: user2.id,
                                       commentable_type: "Comment")

      CommentMailer.new_comment_notification(nestedcomment)
      
    end
  end
end
