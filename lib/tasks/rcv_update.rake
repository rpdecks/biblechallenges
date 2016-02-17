namespace :rcv do
  desc "manage RCV within app, taking care of copyright/availablility at LSM API"

  task update_version: :environment do

    CSV.foreach('db/chapters.csv', headers: true) do |row|
      chapter = Chapter.find_by_book_id_and_chapter_number((row["book_id"].to_i), (row["chapter_number"].to_i))
      chapter.verses.by_version("RCV")
    end
  end
end
