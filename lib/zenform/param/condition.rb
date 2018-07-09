module Zenform
  module Param
    class Condition < RuleBase
      FIELDS = %w{field operator value}
      FIELDS.each { |field| attr_reader field }
    end
  end
end
