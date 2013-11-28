include Warden::Test::Helpers

module FeatureHelpers
  def login(user= create(:user))
    login_as user, scope: :user
    user
  end
end