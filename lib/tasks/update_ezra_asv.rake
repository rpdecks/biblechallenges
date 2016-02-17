namespace :verses do
  desc "manage RCV within app, taking care of copyright/availablility at LSM API"

#  task new_ezra: :environment do
#
#    CSV.foreach('db/ezra.csv', headers: true) do |row|
#      binding.pry
#      Verse.create(version: "ASV", book_name: row["book_name"], book_id: row["book_id"].to_i, chapter_number: row["chapter_number"].to_i, chapter_index: row["chapter_index"].to_i, verse_number: row["verse_number"].to_i, versetext: row["versetext"])
#      puts("#{row["book_name"]} #{row["chapter_number"]}")
#    end
#  end

  task update_ezra_book_id: :environment do

    ezra_verses_with_bad_book_id = Verse.where(book_id: 26, book_name: "Ezra")
    ezra_verses_with_bad_book_id.each do |v|
      v.update_attributes(book_id: 15)
      puts("#{v.book_name} #{v.chapter_number} #{v.verse_number}")
    end
  end
end
