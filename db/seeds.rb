require 'csv'

# USAGE:
#
#   MassImporter.import Model, "path/to/csv_data"
#
module MassImporter
  class << self
    def import(ar_model, csv_file, append = false, csvoptions = {})

      print "Importing #{ar_model.to_s} from #{csv_file}..."
      @table = CSV.read(csv_file, csvoptions)
      @columns = @table.headers
      @values = @table.values_at *@columns
      ar_model.destroy_all unless append # Prevents duplicate records by default
      ar_model.import @columns, @values, validate: false
      puts "Done!"
    end
  end
end

MassImporter.import Chapter, "db/chapters.csv", false, headers: true
MassImporter.import Bookfrag, "db/bookfrags.csv", false, headers: true

MassImporter.import Verse, "db/versions/ASV_OLD.tsv", false, :col_sep => "\t", headers: true
MassImporter.import Verse, "db/versions/ASV.tsv", true, :col_sep => "\t", headers: true
MassImporter.import Verse, "db/versions/ESV.tsv", true, :col_sep => "\t", headers: true
MassImporter.import Verse, "db/versions/KJV.tsv", true, :col_sep => "\t", headers: true
MassImporter.import Verse, "db/versions/NASB.tsv", true, :col_sep => "\t", headers: true
MassImporter.import Verse, "db/versions/NKJV.tsv", true, :col_sep => "\t", headers: true

#This below is for the verses, which come from tab delimited files

