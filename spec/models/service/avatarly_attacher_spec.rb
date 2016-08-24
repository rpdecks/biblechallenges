require 'spec_helper'

describe AvatarlyAttacher do
  describe '#attach' do
    it 'does nothing if the passed in user already has an avatar' do
      user = create(:user_with_avatar)

      expect{
        AvatarlyAttacher.new(user).attach
      }.not_to change{[user.avatar_file_name, user.avatar_file_size]}
    end

    it 'attaches an avatarly avatar based on the users name if the user has no avatar' do
      user = create(:user)
      AvatarlyAttacher.new(user).attach

      expect(user.avatar_file_name).to_not be_nil
      expect(user.avatar_file_size).to_not be_nil
    end
  end

end
