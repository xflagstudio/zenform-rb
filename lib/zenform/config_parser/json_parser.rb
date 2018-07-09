module Zenform
  module ConfigParser
    module JSONParser
      class << self
        def parse(file_path, format)
          data = File.open(file_path) { |f| JSON.load f }
          case data
          when Array
            data.map { |row| slice_valid_fields row, format["fields"] }
          when Hash
            slice_valid_fields data, format["fields"]
          end
        end

        def slice_valid_fields(row, fields)
          row.slice *fields.map { |f| f["name"] }
        end
      end
    end
  end
end
