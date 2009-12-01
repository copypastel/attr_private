module ActiveRecord
  class Base
    class << self
      def attr_private(*attributes)
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
      reject_private_attributes!(attrs) unless allow_private_access?
      attrs
    end

    alias old_attributes_before_type_cast attributes_before_type_cast
    def attributes_before_type_cast
      attrs = old_attributes_before_type_cast
      reject_private_attributes!(attrs) unless allow_private_access?
      attrs
    end

    private
    def reject_private_attributes!(attrs)
      self.class.private_attributes.each do |attr|
        attrs.reject! { |key,value| key.to_s == attr.to_s }
      end 
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
