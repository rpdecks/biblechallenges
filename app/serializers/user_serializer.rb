class UserSerializer < ActiveModel::Serializer
  root false
  attributes :id, :name, :avatar_path

  def avatar_path
    '/assets/default_avatar.png'
  end
end