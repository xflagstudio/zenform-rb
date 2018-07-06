require "csv"
require "zenform/config_parser/csv_parser/value_converter"

module Zenform
  module ConfigParser
    module CSVParser
      class << self
        def parse(file_path, format)
          content_list = load_csv(file_path, format["fields"]).map.with_index do |row, i|
            begin
              valid_type_config = slice_valid_fields row, format["fields"]
              combined_config = combine_values valid_type_config, format["combinator"]
              nest_keys combined_config
            rescue => e
              line = i + 2 # because of 0-indexed and excpeted header
              raise Zenform::ParseError.new file_path, line, e
            end
          end
          content_list.inject({}) do |map, content|
            slug = content.delete "slug"
            map.merge slug => content
          end
        end

        private

        def load_csv(file_path, fields)
          CSV.readlines(file_path, headers: true, converters: ValueConverter.create(file_path, fields)).map(&:to_h)
        end

        def slice_valid_fields(row, fields)
          row.slice *fields.map { |f| f["name"] }
        end

        def combine_values(row, combinators)
          return row if combinators.nil?

          combinated_row = Marshal.load(Marshal.dump(row))
          combinators.each do |combinator|
            keys = combinator["sources"].map { |s| s["key"] }

            sources = combinator["sources"].map do |source|
              combinated_row.delete(source["source_name"]) || []
            end
            if sources.map(&:size).uniq.size > 1
              raise Zenform::CombineError.new(combinator["sources"].map { |s| s["source_name"] })
            end

            combinated_row[combinator["dest"]] = sources.transpose.map do |values|
              Hash[keys.zip(values)]
            end
          end
          combinated_row
        end

        def nest_keys(row)
          row.each_with_object({}) do |(full_key, value), nested_row|
            keys = full_key.split(".")
            tail_key = keys.pop
            hash = keys.inject(nested_row) do |h, key|
              h[key] ||= {}
            end
            hash[tail_key] = value
          end
        end
      end
    end
  end
end
