module Zenform
  module Param
    class TicketForm < Base
      FIELDS = %w{name position end_user_visible display_name ticket_field_ids}
      FIELDS.each { |field| attr_reader field }
      attr_reader :ticket_fields

      def initialize(content, ticket_fields: {}, **_params)
        super
        @ticket_fields = ticket_fields
      end

      def validate!
        %w{name position}.each { |field| validate_field! field }

        ticket_field_ids.each do |ticket_field_id|
          if ticket_fields.keys.exclude? ticket_field_id
            raise Zenform::ContentError.new self.class, "ticket_field_ids", ticket_field_id
          end
        end
      end

      def format
        to_h.merge("ticket_field_ids" => ticket_field_ids.map { |slug| ticket_fields[slug]["id"] })
      end
    end
  end
end
