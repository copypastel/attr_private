module ActiveRecord
  class Base
    class << self
      def attr_private(*attributes)
        @set = Set.new(attributes.map { |a| a.to_s }) + (@set || [])
        write_inheritable_attribute(:attr_private,@set)
      end
    end
  end
end
