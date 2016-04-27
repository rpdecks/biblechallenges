class RetrieveRcv

  EXPIRED_CACHE = 30
  
  def initialize(chapter)
    @chapter = chapter
  end

  def cache_chapter
    rcv_verses = RcvBible::Reference.new(@chapter.book_and_chapter).verses

    rcv_verses.each.with_index(1) do |v, index|
      if v['text']
        Verse.create(version: "RCV", book_name: @chapter.book_name,
                          chapter_number: @chapter.chapter_number,
                          verse_number: index,
                          versetext: v["text"],
                          book_id: @chapter.book_id,
                          chapter_index: @chapter.chapter_index)
      end
    end
  end

  def retouch_rcv_chapter
    cached_verses.each { |verse| verse.touch}
  end

  def refresh
    if chapter_missing?
      cache_chapter
    elsif chapter_present? && expired_cache?
      retouch_rcv_chapter
    end
  end

  def chapter_missing?
    cached_verses.empty?
  end

  def chapter_present?
    cached_verses.any?
  end

  def expired_cache?
    cached_verses.first.updated_at < EXPIRED_CACHE.days.ago
  end

  def cached_verses
    @cached_verses ||= @chapter.verses.where(version: 'RCV')
  end

  def book_and_chapter
    @chapter.book_name + " " + @chapter.chapter_number.to_s
  end

end
