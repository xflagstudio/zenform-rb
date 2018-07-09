module Zenform
  module Commands
    module Apply
      class TicketForm <  Base
        def content_name
          :ticket_forms
        end

        private

        def extra_params
          ticket_fields ||= Zenform::FileCache.read(project_path, "ticket_fields")
          ticket_fields ||= {}
          { ticket_fields: ticket_fields }
        end
      end
    end
  end
end
