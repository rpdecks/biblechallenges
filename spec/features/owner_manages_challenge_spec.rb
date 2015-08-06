require 'spec_helper'

feature 'Owner manages challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'Changes the name of the challenge after the challenge has been created' do
    challenge = create(:challenge, owner_id: user.id, name: "Awesome")
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    click_link 'Edit Challenge'
    fill_in 'Challenge Name', with: "Wonderful"
    click_button 'Update'
    expect(page).to have_content("Successfully updated challenge")
    challenge.reload
    expect(challenge.name).to eq "Wonderful"
  end

  scenario 'Sends an email message to all members belonging to the challenge' do
    Sidekiq::Testing.inline! do
      challenge = create(:challenge, owner_id: user.id, name: "Awesome")
      create(:membership, challenge: challenge, user: user)
      user2 = create(:user, email: "guy@example.com")
      user3 = create(:user, email: "phil@example.com")
      challenge.join_new_member([user2, user3])
      visit creator_challenge_path(challenge)
      click_link ('Email All Members')
      fill_in 'message', with: "Hello everyone"
      click_button 'Send message'
      message_emails = ActionMailer::Base.deliveries
      expect(page).to have_content("You have successfully sent your message")
      expect(message_emails.first.to).to eq [user2.email]
      expect(message_emails.last.to).to eq [user3.email]
      expect(message_emails.count).to eq 2
      expect(message_emails.first.body).to have_content("Hello everyone")
    end
  end

  scenario 'Forgets to add a message' do
    challenge = create(:challenge, owner_id: user.id, name: "Awesome")
    create(:membership, challenge: challenge, user: user)
    user2 = create(:user, email: "guy@example.com")
    challenge.join_new_member(user2)
    visit creator_challenge_path(challenge)
    click_link ('Email All Members')
    click_button 'Send message'
    expect(page).to have_content("You need to include a message")
    message_emails = ActionMailer::Base.deliveries
    expect(message_emails.count).to eq 0
  end

  scenario 'Deletes a user from challenge' do
    challenge = create(:challenge, owner_id: user.id, name: "Awesome")
    create(:membership, challenge: challenge, user: user)
    user2 = create(:user, email: "guy@example.com")
    challenge.join_new_member(user2)
    membership2 = Membership.last
    visit creator_challenge_path(challenge)
    click_link ("remove_#{membership2.id}")
    expect(challenge.members.count).to eq 1
    expect(challenge.members.first.email).to eq user.email
  end
end
