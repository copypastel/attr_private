module ActiveRecord::AttributeMethods::ClassMethods
  def define_read_method(symbol,attr_name,column)
    cast_code = column.type_cast_code('v') if column
    access_code = cast_code ? "(v=@attributes['#{attr_name}']) && #{cast_code}" : "@attributes['#{attr_name}']"

    unless attr_name.to_s == self.primary_key.to_s
      access_code = access_code.insert(0, "missing_attribute('#{attr_name}', caller) unless @attributes.has_key?('#{attr_name}'); ")
    end
    
    if cache_attribute?(attr_name)
      access_code = "@attributes_cache['#{attr_name}'] ||= (#{access_code})"
    end
    unless private_attributes.include?(attr_name)
      evaluate_attribute_method attr_name, "def #{symbol}; #{access_code}; end"
    else
      method = "
      def #{attr_name} 
      end
      private :#{attr_name}
      "
      evaluate_attribute_method attr_name, method 
    end
  end

  def define_write_method(attr_name)
    method = "def #{attr_name}=(new_value);write_attribute('#{attr_name}', new_value);end; private :#{attr_name}"
    evaluate_attribute_method attr_name, method, "#{attr_name}="
  end
end

