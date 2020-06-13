namespace :dups do
  desc "find dups"

  task find: :environment do
    # Chapter.order(:chapter_index).each do |chapter|
    #   puts "#{chapter.book_name} #{chapter.chapter_number}"
    #   puts "\t#{chapter.verses.where(version: 'RCV').size}"
    # end

    puts Verse.where(version: 'RCV').size
    Verse.all.each do |v|
      # print '.'
      if (Verse.where(
          version: v.version,
          book_name: v.book_name,
          chapter_number: v.chapter_number,
          verse_number: v.verse_number,
          book_id: v.book_id).count) > 1
        # puts "#{v.book_name} #{v.chapter_number} #{v.verse_number} is a dup"
        v.destroy
      end
    end
  end
end
