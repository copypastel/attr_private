require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.dirname(__FILE__) + '/../../../config/boot'
require 'tasks/rails'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the attr_private plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the attr_private plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AttrPrivate'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
