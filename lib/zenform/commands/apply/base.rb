module Zenform
  module Commands
    module Apply
      class Base
        attr_reader :client, :project_path, :new_contents, :shell
        MESSAGE_SKIPPED = "Skipped to create %{count} %{content_name} because they are already created."
        MESSAGE_SUCCESS = "Success to create %{content_name}(slug: %{slug})!"
        MESSAGE_FAILED  = "Failed to create %{content_name}(slug: %{slug}) because %{error}."

        def initialize(client, project_path, new_contents, shell)
          @client = client
          @project_path = project_path
          @new_contents = create_param_list new_contents
          @shell = shell
        end

        def run
          created_contents = not_created_contents.map { |slug, content| [slug, create(content, slug)] }.to_h.compact
          Zenform::FileCache.write project_path, content_name, cached_contents.merge(created_contents)
        end

        def content_name
          raise NotImplementedError
        end

        private

        def cached_contents
          @cached_contents ||= Zenform::FileCache.read(project_path, content_name)
          @cached_contents ||= {}
          @cached_contents
        end

        def not_created_contents
          already_created, not_created = new_contents.partition { |slug, _| cached_contents.keys.include? slug }.map(&:to_h)
          if already_created.present?
            shell.say MESSAGE_SKIPPED % { content_name: content_name, count: already_created.size }
            shell.indent { already_created.keys.each { |slug| shell.say slug } }
          end
          not_created
        end

        def create_param_list(contents)
          param_klass = Zenform::Param.const_get self.class.to_s.split("::").last
          contents.inject({}) { |map, (slug, content)| map.merge slug => param_klass.new(content, extra_params) }
        end

        def extra_params
          raise NotImplementedError
        end

        def create(content, slug = nil)
          message_params = { method: __method__, content_name: content_name, slug: slug }
          content = client.send(content_name).create!(content.tap(&:validate!).format)
          shell.say MESSAGE_SUCCESS % message_params, :green
          content.to_h
        rescue ZendeskAPI::Error::ClientError, Zenform::ContentError => e
          shell.say MESSAGE_FAILED % message_params.merge(error: e.to_s), :red
          nil
        end
      end
    end
  end
end
