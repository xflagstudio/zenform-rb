module Zenform
  module Param
    class Action < RuleBase
      FIELDS = %w{field value}
      FIELDS.each { |field| attr_reader field }
    end
  end
end
