class ChapterGenerator
  def initialize(challenge)
    @challenge = challenge
  end

  def retrieve_chapters_to_read
    return build_string
  end

  def build_string
    starting_book = @challenge.begin_book
    ending_book = LAST_CHAPTER_OF_BOOK["#{@challenge.end_book}"]
    starting_book + " 1-" + ending_book
  end

  LAST_CHAPTER_OF_BOOK = {
    'Genesis' => 'Genesis 50', 
    'Exodus' => 'Exodus 40', 
    'Leviticus' => 'Leviticus 27',
    'Numbers' => 'Numbers 36',
    'Deuteronomy' => 'Deuteronomy 34',
    'Joshua' => 'Joshua 24',
    'Judges' => 'Judges 21',
    'Ruth' => 'Ruth 4',
    '1 Samuel' => '1 Samuel 31',
    '2 Samuel' => '2 Samuel 24',
    '1 Kings' => '1 Kings 22',
    '2 Kings' => '2 Kings 25',
    '1 Chronicles' => '1 Chronicles 29',
    '2 Chronicles' => '2 Chronicles 36',
    'Ezra' => 'Ezra 10',
    'Nehemiah' => 'Nehemiah 13',
    'Esther' => 'Esther 10',
    'Job' => 'Job 42',
    'Psalms' => 'Psalm 150',
    'Proverbs' => 'Proverbs 31',
    'Ecclesiastes' => 'Ecclesiastes 12',
    'Song of Songs' => 'Song of Songs 8',
    'Isaiah' => 'Isaiah 66',
    'Jeremiah' => 'Jeremiah 52',
    'Lamentations' => 'Lamentations 5',
    'Ezekiel' =>  'Ezekiel 48',
    'Daniel' => 'Daniel 12',
    'Hosea' => 'Hosea 14',
    'Joel' => 'Joel 3',
    'Amos' => 'Amos 9',
    'Obadiah' =>  'Obadiah 1',
    'Jonah' => 'Jonah 4',
    'Micah' => 'Micah 7',
    'Nahum' => 'Nahum 3',
    'Habakkuk' => 'Habakkuk 3',
    'Zephaniah' => 'Zephaniah 3',
    'Haggai' => 'Haggai 2',
    'Zechariah' => 'Zechariah 14',
    'Malachi' => 'Malachi 4',
    'Matthew' => 'Matthew 28',
    'Mark' => 'Mark 16',
    'Luke' => 'Luke 24',
    'John' => 'John 21',
    'Acts' => 'Acts 28',
    'Romans' => 'Romans 16',
    '1 Corinthians' =>  '1 Corinthians 16',
    '2 Corinthians' => '2 Corinthians 13',
    'Galatians' => 'Galatians 6',
    'Ephesians' => 'Ephesians 6',
    'Philippians' => 'Philippians 4',
    'Colossians' => 'Colossians 4',
    '1 Thessalonians' => '1 Thessalonians 5',
    '2 Thessalonians' => '2 Thessalonians 3',
    '1 Timothy' => '1 Timothy 6',
    '2 Timothy' => '2 Timothy 4',
    'Titus' => 'Titus 3',
    'Philemon' => 'Philemon 1',
    'Hebrews' => 'Hebrews 13',
    'James' => 'James 5',
    '1 Peter' => '1 Peter 5',
    '2 Peter' => '2 Peter 3',
    '1 John' => '1 John 5',
    '2 John' => '2 John 1',
    '3 John' => '3 John 1',
    'Jude' => 'Jude 1',
    'Revelation' => 'Revelation 22' }
end
