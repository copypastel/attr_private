module ActiveRecord
  class Base
    class << self
      def attr_private(*attributes)
        attributes.each do |a|
          self.class_eval(<<-EOS)
            attr_protected :_#{a}
            def #{a}()
              self._#{a}
            end
            def #{a}=(new_value)
              self._#{a} = new_value
            end
            private :#{a}
            private :#{a}=
          EOS
        end
        write_inheritable_attribute(:attr_private,Set.new(attributes.map { |a| a.to_s }) + (private_attributes || []))
      end

      def private_attributes
        read_inheritable_attribute(:attr_private)
      end
    end
  end
end
