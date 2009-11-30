module ActiveRecord
  class Base
    class << self
      def attr_private(*attributes)
        attributes.each do |a|
          #TODO: Tried to put this in attribute_methods.rb but the private calls were ignored...
          # In the future this should be moved there to match rails current style.
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
