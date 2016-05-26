class UserSerializer < ActiveModel::Serializer
	include ActionView::Helpers::AssetUrlHelper
	
  root false
  attributes :id, :name, :avatar_path

  def avatar_path
    user = object

    if user && user.avatar_file_name
      user.avatar.url(:thumb)
    else
      user.image || '/assets/default_avatar.png'
    end
  end
end