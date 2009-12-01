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
    #      #return nil if self.class.private_attributes.any? {|a| #{attr} == _#\:{a}} and not allow_private_access?
          old_#{attr}(args)
        end
      EOS
    end
  end

  PRIVATE_ACCESSORS = [
=begin codegen :private_accessors
  ['read_attribute', 'read_attribute_before_type_cast','attributes']
=end
  ] 
      
end
