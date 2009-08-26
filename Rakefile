require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test RubyCloud'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rubycloud"
    gemspec.summary = "A Ruby Provisioning Library"
    gemspec.description = "Cross-provider provisioning of compute nodes."
    gemspec.email = "ogc@ogtastic.com"
    gemspec.homepage = "http://github.com/flogic/rubycloud"
    gemspec.authors = ["Kevin Barnes", "Rick Bradley", "Yossef Mendelssohn", "Ryan Waldron"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
