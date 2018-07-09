module Zenform
  class CombineError < StandardError
    attr_reader :keys
    def initialize(keys)
      @keys = keys

      super "Values are not same length. keys: #{keys}"
    end
  end
  class ParseError < StandardError
    attr_reader :path, :line_num, :parent_error
    def initialize(path, line_num, parent_error)
      @path = path
      @line_num = line_num
      @parent_error = parent_error

      super "#{@path}:#{@line_num}: parse error: #{@parent_error}"
    end
  end
  class TypeConversionError < StandardError
    attr_reader :keys
    def initialize(type, value)
      @type = type
      @value = value

      super "Value `#{value.inspect}` is invalid form. type: #{@type}"
    end
  end
  class ContentError < StandardError
    attr_reader :content_name, :field, :value
    def initialize(content_name, field, value)
      @content_name = content_name
      @field = field
      @value = value

      super "#{content_name}' #{field} (#{value.inspect}) is invalid form."
    end
  end
end
