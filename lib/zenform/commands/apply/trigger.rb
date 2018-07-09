module Zenform
  module Commands
    module Apply
      class Trigger <  Base
        def content_name
          :triggers
        end

        private

        def extra_params
          ticket_fields = Zenform::FileCache.read(project_path, "ticket_fields") || {}
          ticket_forms = Zenform::FileCache.read(project_path, "ticket_forms") || {}
          { ticket_fields: ticket_fields, ticket_forms: ticket_forms }
        end
      end
    end
  end
end
