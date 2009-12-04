=begin codegen :auto_header
# This is an Auto Generated File.
# Please edit active_record_attribute_methods_codegen_template.rb to change the contents.
=end
module ActiveRecord
  module AttributeMethods
    #TODO: Figure out how to get this next array into a variable that can be accesesd 
    # via the codegen as well.
    ['read_attribute','read_attribute_before_type_cast'].each do |attr|
      module_eval(<<-EOS)
        alias old_#{attr} #{attr}
        def #{attr}(*args)
          return nil if self.class.private_attributes.include?(args.first.to_s) and not allow_private_access?
          old_#{attr}(*args)
        end
      EOS
    end

    module ClassMethods
      def define_write_method(attr_name)
        method = "def #{attr_name}=(new_value);write_attribute('#{attr_name}', new_value);end"
        if not private_attributes.nil? and private_attributes.include?(attr_name.to_s)
          method = <<-EOS
            def #{attr_name}=(new_value)
              raise NoMethodError, "private method `#{attr_name}' called for #{self}" unless allow_private_access?
              write_attribute('#{attr_name}',new_value)
            end
          EOS
        end
        evaluate_attribute_method(attr_name, method,"#{attr_name}=")
      end

      def define_read_method(symbol, attr_name, column)
        cast_code = column.type_cast_code('v') if column
        access_code = cast_code ? "(v=@attributes['#{attr_name}']) && #{cast_code}" : "@attributes['#{attr_name}']"

        unless attr_name.to_s == self.primary_key.to_s
          access_code = access_code.insert(0, "missing_attribute('#{attr_name}', caller) unless @attributes.has_key?('#{attr_name}'); ")
        end
        
        if cache_attribute?(attr_name)
          access_code = "@attributes_cache['#{attr_name}'] ||= (#{access_code})"
        end
        method = "def #{symbol}; #{access_code}; end"
        if not private_attributes.nil? and private_attributes.include?(attr_name)
          method = <<-EOS
            def #{attr_name}
              raise NoMethodError, "private method `#{attr_name}' called for #{self}" unless allow_private_access?
              #{access_code}
            end
          EOS
        end
        evaluate_attribute_method attr_name, method 
      end
    end

  end # AttributeMethods

  PRIVATE_ACCESSORS = [
=begin codegen :private_accessors
  ['read_attribute', 'read_attribute_before_type_cast','attributes', 'define_read_method', 'define_write_method']
=end
  ] 
      
end
