module Zenform
  module Param
    class TicketField < Base
      FIELDS = %w{title type visible_in_portal editable_in_portal required_in_portal description custom_field_options}
      FIELDS.each { |field| attr_reader field }

      def validate!
        %w{title type}.each { |field| validate_field! field }

        validate_field!("custom_field_options") if type == "tagger"
      end

      def format
        to_h
      end
    end
  end
end
