module ActiveRecord
  class Base
    class << self
      def attr_private(*attributes)
        write_inheritable_attribute(:attr_private,Set.new(attributes.map { |a| a.to_s }) + (private_attributes || []))
      end

      def private_attributes
        read_inheritable_attribute(:attr_private)
      end
    end
  end
end
