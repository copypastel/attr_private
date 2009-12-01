# AttrPrivate

lib = File.expand_path(File.dirname(__FILE__) + '/attr_private')
$:.unshift(lib) unless $:.include? lib

require 'active_record_base'
begin
  require 'active_record_attribute_methods'
rescue MissingSourceFile 
  raise "Please run rake rails:freeze:edge RELEASE=#\{verison}. Then run vendor/plugin/attr_accessor/bin/codegen. See README for details about why this is nessisary."
end
