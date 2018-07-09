module Zenform
  module Param
    class RuleBase < Base
      attr_reader :ticket_fields, :ticket_forms

      FIELD_PARAM_FOR_TICKET_FIELD = "custom_fields_%{id}"

      def initialize(content, ticket_fields: {}, ticket_forms: {}, **_params)
        super
        normalize
        @ticket_fields = ticket_fields
        @ticket_forms = ticket_forms
      end

      def validate!
        return if field != "ticket_form_id"
        return if ticket_forms.keys.include? value
        raise Zenform::ContentError.new self.class, "ticket_form_id", value
      end

      def format
        to_h.merge(
          "field" => formatted_field,
          "value" => formatted_value
        )
      end

      def normalize
        @value = value.first if value.is_a?(Array) && value.size == 1
      end

      def formatted_field
        ticket_field_id = ticket_fields[field].try(:fetch, "id")
        ticket_field_id ? (FIELD_PARAM_FOR_TICKET_FIELD % { id: ticket_field_id }) : field
      end

      def formatted_value
        ticket_forms[value].try(:fetch, "id") || value
      end
    end
  end
end
