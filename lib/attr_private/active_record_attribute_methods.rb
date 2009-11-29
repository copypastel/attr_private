module ActiveRecord::AttributeMethods::ClassMethods
  private
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
      method = "def #{symbol} 
        raise NoMethodError
      end"
      evaluate_attribute_method attr_name, method 
    end
  end
end
