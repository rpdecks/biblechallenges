namespace :avatarly do
  desc "generate default avatars for needy users"

  task generate: :environment do
    User.where(avatar_file_name: nil).each do |user|
      AvatarlyAttacher.new(user).attach
      print '.'
    end
  end
end
