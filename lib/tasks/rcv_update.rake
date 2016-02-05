namespace :rcv do
  desc "manage RCV within app, taking care of copyright/availablility at LSM API"

  require 'fastercsv'

  task update_version: :environment do
    new_file = FasterCSV.new('../../db/versions/RCV.tsv', col_sep: "\t", headers: true)

    FasterCSV.foreach('../../db/versions/ASV_OLD.tsv', col_sep: "\t", headers: true) do |row|
      RcvBible::Reference.new("#{'book_name'} ##{chapter_number} {verse_number}").verses
    end
    FasterCSV.foreach('../../db/versions/ESV.tsv', col_sep: "\t", headers: true) do |row|
    end
  end
end
