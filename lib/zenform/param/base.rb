module Zenform
  module Param
    class Base
      FIELDS = []

      def self.fields
        const_get("FIELDS")
      end

      def initialize(content, **_params)
        fields = self.class.fields
        raise NotImplementedError if fields.empty?

        fields.each { |field| instance_variable_set "@#{field}", content[field] }
      end

      def validate!(content)
        raise NotImplementedError
      end

      def format
        raise NotImplementedError
      end

      def validate_field!(field, value = send(field))
        raise Zenform::ContentError.new self.class, field, value if value.blank?
      end

      def to_h
        self.class.fields.inject({}) { |map, f| map.merge f => send(f) }
      end

      def reject_blank_field(hash)
        hash.each_with_object({}) do |(key, value), h|
          value = reject_blank_field(value) if value.is_a? Hash
          h[key] = value if value.present?
        end
      end
    end
  end
end
