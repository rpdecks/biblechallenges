namespace :rcv do
  desc "check for duplicate chapters/verses for version RCV"

  task wipe_duplicates: :environment do

    duplicate_chapters = []

    Chapter.all.each do |chapter|
      chapter_rcv_verses_array = chapter.verses.where(version: "RCV").to_a
      unless (chapter_rcv_verses_array.uniq { |v| v.verse_number }.size) == chapter_rcv_verses_array.size
        duplicate_chapters << chapter
      end
    end
    puts "These Chapters have duplicates:"
    duplicate_chapters.each do |chapter|
      puts "#{chapter.book_name}" + " " + "#{chapter.chapter_number}"
    end
    print "Proceed with removal of duplicates? Y/N => "
    prompt = STDIN.gets.chomp
    if prompt == "Y" || prompt == "y"
      duplicate_chapters.each do |chapter|
        chapter.destroy
        chapter.by_version("RCV")
      end
    else
      break
    end
  end
end
