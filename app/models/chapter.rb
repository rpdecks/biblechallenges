# == Schema Information
#
# Table name: chapters
#
#  id             :integer          not null, primary key
#  book_name      :string(255)
#  chapter_number :integer
#  chapter_index  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  book_id        :integer
#

class Chapter < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges

  has_many :bookfrags, primary_key: :book_number, foreign_key: :book_number

  # Class methods
  def self.search(query)
    fragment, chapters = parse_query(query)

    # First search by fragment
    bookfrag = Bookfrag.where("upper(:query) like upper(fragment) || '%'",
                              query: fragment).first
    matches = where(book_id: bookfrag.try(:book_id))
    .where(chapter_number: chapters)

    # If nothing found, then search by Chapter name
    unless matches.length > 0 # Using .any? here causes an extra query
      matches = where("upper(book_name) like upper(:query)", query: "#{fragment}")
      .where(chapter_number: chapters)
    end

    matches
  end

  def self.parse_query(query)
    regex = /^\s*([0-9]?\s*[a-zA-Z]+)\.?\s*([0-9]+)(?:\s*(?:-|..)[^0-9]*([0-9]+))?/
    match = query.match(regex)
    if match
      if match[3]
        chapters = (match[2]..match[3]).to_a
      else
        chapters = [ match[2] ]
      end
      [ match[1].gsub(/ /, ""), chapters ]
    else
      [nil, nil]
    end
  end

end
