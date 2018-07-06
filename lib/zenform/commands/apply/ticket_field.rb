module Zenform
  module Commands
    module Apply
      class TicketField <  Base
        def content_name
          :ticket_fields
        end

        private

        def extra_params
          {}
        end
      end
    end
  end
end
