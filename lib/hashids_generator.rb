class HashidsGenerator

  include Singleton

  def initialize
    @hashids = Hashids.new("SbrB5u8(d1Jk#jS&",8)
  end

  def decrypt(s)
    @hashids.decrypt(s)
  end

  def encrypt(numberz)
    @hashids.encode(numberz)
  end

end
