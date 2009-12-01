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

    alias old_attributes attributes
    def attributes
      attrs = old_attributes
      self.class.private_attributes.each do |a|
        attrs.reject! { |key,value| key == "_#{a}" }
      end unless allow_private_access?
      attrs
    end
    
    def allow_private_access?
      # Check to see if the second caller (because the first would be the method that called this function)
      # was invoked from within the allowable PRIVATE_ACCESSORS list
      file = caller(2).map { |c| c.split(':').first.split('/').last }.first
      access = ActiveRecord::PRIVATE_ACCESSORS + ["#{self.class.name.to_s.underscore}.rb"]
      access.include? file
    end

  end
end
