class Bookfrag < ActiveRecord::Base
  belongs_to :chapter, primary_key: :book_id, foreign_key: :book_id
end
