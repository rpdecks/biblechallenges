require 'csv'

# USAGE:
#
#   MassImporter.import Model, "path/to/csv_data"
#
module MassImporter
  class << self
    def import(ar_model, csv_file)
      print "Importing #{ar_model.to_s} from #{csv_file}..."
      @table = CSV.read(csv_file, headers: true)
      @columns = @table.headers
      @values = @table.values_at *@columns
      ar_model.destroy_all # Prevents duplicate records
      ar_model.import @columns, @values, validate: false
      puts "Done!"
    end
  end
end

MassImporter.import Chapter, "db/chapters.csv"
MassImporter.import Bookfrag, "db/bookfrags.csv"
