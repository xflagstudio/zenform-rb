require "zenform/config_parser/csv_parser"
require "zenform/config_parser/json_parser"
require "yaml"

module Zenform
  module ConfigParser
    DEFAULT_CONFIG_PATH = "./zendesk_config"
    TEMPLATE_PATH = File.expand_path("../../config/parse_format.yml", File.dirname(__FILE__))

    class << self
      def parse(project_path)
        YAML.load_file(TEMPLATE_PATH).inject({}) do |config, (content, format)|
          config.merge content => load_config(project_path, format)
        end
      end

      private

      def load_config(project_path, format)
        file_path = File.expand_path format["path"], project_path
        case format["file_type"]
        when "csv"
          Zenform::ConfigParser::CSVParser.parse file_path, format
        when "json"
          Zenform::ConfigParser::JSONParser.parse file_path, format
        end
      end
    end
  end
end
