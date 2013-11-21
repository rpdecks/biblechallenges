# == Schema Information
#
# Table name: bookfrags
#
#  id         :integer          not null, primary key
#  fragment   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer
#

class Bookfrag < ActiveRecord::Base
end