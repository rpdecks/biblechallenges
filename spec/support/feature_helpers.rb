include Warden::Test::Helpers

module FeatureHelpers
  def login(user= create(:user))
    login_as user, scope: :user
    user
  end

  def clean_test_uploads
    test_uploads = Dir["#{Rails.root}/tmp/test_uploads"]
    FileUtils.rm_rf(test_uploads)
  end
end
