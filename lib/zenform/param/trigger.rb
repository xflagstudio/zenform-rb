module Zenform
  module Param
    class Trigger < Base
      FIELDS = %w{title position conditions actions}
      FIELDS.each { |field| attr_reader field }
      attr_reader :ticket_fields, :ticket_forms

      def initialize(content, ticket_fields: {}, ticket_forms: {}, **_params)
        super
        @ticket_fields = ticket_fields
        @ticket_forms = ticket_forms
        normalize
      end

      def validate!
        validate_conditions!
        validate_actions!
      end

      def format
        to_h.merge "conditions" => formatted_conditions, "actions" => actions.map(&:format)
      end

      private

      def normalize
        @conditions = conditions.inject({}) do |h, (assoc_rule, conds)|
          h.merge assoc_rule => conds.map { |c| Condition.new(c, ticket_fields: ticket_fields, ticket_forms: ticket_forms) }
        end
        @actions = actions.map { |a| Action.new(a, ticket_fields: ticket_fields, ticket_forms: ticket_forms) }
      end

      def validate_conditions!
        flatten_conditions = conditions["all"] + conditions["any"]

        validate_field! "conditions", flatten_conditions
        flatten_conditions.each(&:validate!)
      end

      def validate_actions!
        validate_field! "actions"
        actions.each(&:validate!)
      end

      def formatted_conditions
        compact_conditions = reject_blank_field(conditions)
        compact_conditions.inject({}) { |h, (key, value)| h.merge key => value.map(&:format) }
      end
    end
  end
end
