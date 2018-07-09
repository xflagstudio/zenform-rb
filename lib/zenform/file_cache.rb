module Zenform
  module FileCache
    FILENAME = "%{content_name}_cache.json"
    class << self
      def read(project_path, content_name)
        file_path = create_file_path project_path, content_name
        return unless File.exists? file_path

        JSON.parse(File.read(file_path))
      end

      def write(project_path, content_name, data)
        file_path = create_file_path project_path, content_name
        File.open(file_path, "w") { |f| f.puts data.to_json }
      end

      private

      def create_file_path(project_path, content_name)
        File.expand_path FILENAME % { content_name: content_name }, project_path
      end
    end
  end
end
