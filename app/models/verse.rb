# == Schema Information
#
# Table name: verses
#
#  id             :integer          not null, primary key
#  version        :string(255)
#  book_name      :string(255)
#  chapter_number :integer
#  verse_number   :integer
#  versetext      :text
#  book_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Verse < ActiveRecord::Base
  attr_accessible :book_id, :book_name, :chapter_number, :verse_number, :versetext, :version, :chapter_index

  belongs_to :chapter, foreign_key: :chapter_index


end
