class RubyCloud
  def initialize(options)
    raise ArgumentError unless options[:provider] and options[:credentials]
    # RubyCloud::EC2.new(options[:credentials])
  end
end

Dir['vendor/*'].each { |dir|  $:.unshift(File.join(dir, 'lib')) }
require 'rubycloud/linode'
