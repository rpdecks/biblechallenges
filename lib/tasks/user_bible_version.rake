namespace :bible_version do
  desc "copy bible version info from membership model to the user model"

  task move: :environment do
    Membership.all.each do |m|
      userid = m.user.id
      bible_version = m.bible_version
      User.find(userid).update_attributes(bible_version: bible_version)
    end
  end
end
