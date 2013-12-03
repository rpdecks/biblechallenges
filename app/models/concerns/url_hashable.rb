module UrlHashable
  extend ActiveSupport::Concern

  def hash_for_url
    HashidsGenerator.instance.encrypt(id)
  end

end