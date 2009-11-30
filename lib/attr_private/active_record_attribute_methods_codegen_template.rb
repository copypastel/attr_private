=begin codegen :auto_header
# This is an Auto Generated File.
# Please edit active_record_attribute_methods_codegen_template.rb to change the contents.
=end
module ActiveRecord::AttributeMethods
  #TODO: Figure out how to get this next array into a variable that can be accesesd 
  # via the codegen as well.
  ['read_attribute','read_attribute_before_type_cast'].each do |attr|
    module_eval(<<-EOS)
      alias old_#{attr} #{attr}
      def #{attr}(*args)
        old_#{attr}(args) if allow_private_access?
      end
    EOS
  end

  private
  PRIVATE_ACCESSORS = ["#{self.to_s.underscore}.rb",
=begin codegen :private_accessors
  ['read_attribute', 'read_attribute_before_type_cast']
=end
  ] 

  def allow_private_access?
    # Check to see if the second caller (because the first would be the method that called this function)
    # was invoked from within the allowable PRIVATE_ACCESSORS list
   file = caller(2).map { |c| c.split(':').first.split('/').last }.first
   PRIVATE_ACCESSORS.include? file
  end
end
