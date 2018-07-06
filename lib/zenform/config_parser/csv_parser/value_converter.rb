require "json"

module Zenform
  module ConfigParser
    module CSVParser
      module ValueConverter
        TYPES = %w{json bool int}

        class << self
          def create(file_path, fields)
            Proc.new do |value, csv_field_option|
              begin
                field = fields.find { |f| f["name"] == csv_field_option.header }
                next unless field

                if TYPES.include? field["type"]
                  send "parse_as_#{field['type']}", value
                else
                  parse_as_string(value)
                end
              rescue => e
                raise Zenform::ParseError.new file_path, csv_field_option.line, e
              end
            end
          end

          private

          def parse_as_string(value)
            value.to_s
          end

          def parse_as_json(value)
            return if value.nil? || value.size == 0

            JSON.parse value
          end

          def parse_as_bool(value)
            case value
            when "TRUE", "true"
              true
            when "FALSE", "false"
              false
            else
              raise Zenform::TypeConversionError.new("bool", value)
            end
          end

          def parse_as_int(value)
            raise Zenform::TypeConversionError.new("int", value) unless value.match /^\d+$/
            value.to_i
          end
        end
      end
    end
  end
end
