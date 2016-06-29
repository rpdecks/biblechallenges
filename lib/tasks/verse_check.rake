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
        verse = bc_verse.first.versetext
        original_versetext_array = (verse).split
        master_versetext_array = row[5].split
        dif = master_versetext_array - original_versetext_array
        if dif.size >= 9
          bad_verse = OpenStruct.new(bc_verse_text: verse, 
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

  task create_judges_19: :environment do
    require 'csv'
    require 'ostruct'
    file_path = Rails.root + "db/all_bible_verses.csv"
    CSV.foreach(file_path, headers: false) do |row|
      if (row[2] == "Judges") && (row[3] == "19")
        Verse.create(version: "RCV",
                     book_name: row[2],
                     chapter_number: row[3].to_i,
                     verse_number: row[4].to_i,
                     versetext: row[5],
                     book_id: 7,
                     chapter_index: 7019
                    )
      end
    end
  end
end
