namespace :verse_check do
  desc "check each verse's validity"

  task run: :environment do
    require 'csv'
    require 'ostruct'
    missing_verses = []
    bad_verse_text = []

    file_path = Rails.root + "db/all_bible_verses.csv"
    CSV.foreach(file_path, headers: false) do |row|
      bc_verse = Verse.where(version: "RCV", book_name: row[2], chapter_number: row[3], verse_number: row[4])
      if bc_verse.present?
        bc_verse_text = bc_verse.first.versetext
        if bc_verse_text != row[5]
        bad_verse = OpenStruct.new(bc_verse_text: bc_verse_text, 
                                   book_name: row[2],
                                   chapter_number: row[3],
                                   verse_number: row[4],
                                   master_verse_text: row[5])
        bad_verse_text << bad_verse
        end
      else
        error = OpenStruct.new(no_matching_bc_verse: row)
        missing_verses << error
      end
    end
  end
end
