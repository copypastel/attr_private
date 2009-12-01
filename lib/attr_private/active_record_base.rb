module ActiveRecord
  class Base
    class << self
      def attr_private(*attributes)
=begin
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
=end
        attr_protected(attributes)
        write_inheritable_attribute(:attr_private,Set.new(attributes.map { |a| a.to_s }) + (private_attributes || []))
      end

      def private_attributes
        read_inheritable_attribute(:attr_private)
      end
    end

    alias old_attributes attributes
    def attributes
      attrs = old_attributes
      self.class.private_attributes.each do |attr|
        attrs.reject! { |key,value| key == attr }
      end unless allow_private_access?
      attrs
    end
    
    def allow_private_access?
      # Check to see if the second caller (because the first would be the method that called this function)
      # was invoked from within the allowable PRIVATE_ACCESSORS list
      # If the third caller is in method_missing then it is auto_generating code and the fourth caller must be checked
      file = if caller(3).first.split(':').last == "in `method_missing'"
               caller(4).first.split(':').first.split('/').last
             else
               caller(2).first.split(':').first.split('/').last
             end
      access = ActiveRecord::PRIVATE_ACCESSORS + ["#{self.class.name.to_s.underscore}.rb"]
      access.include? file
    end

  end
end
