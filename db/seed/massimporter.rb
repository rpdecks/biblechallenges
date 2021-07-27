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
      
      # ActiveRecord::Base.connection.reset_pk_sequence!(ar_model.table_name)# so the ids always start with one psql only
      puts "Done!"
    end
  end
end

MassImporter.import Chapter, "db/chapters.csv", false, headers: true
MassImporter.import Verse, "db/versions/ALL.tsv", false, :col_sep => "\t", headers: true
