class InvalidProviderError < ArgumentError; end

class RubyCloud
  attr_reader :provider
  
  def initialize(options)
    raise ArgumentError unless options[:provider] and options[:credentials]
    @provider = modularize_provider_string(options[:provider]).new(options[:credentials])
  end
private
  def modularize_provider_string(str)
    RubyCloud.const_get(RubyCloud.constants.find{|c| c.upcase == str.gsub('_', '').upcase})
  rescue TypeError
    raise InvalidProviderError
  end
end

Dir['vendor/*'].each { |dir|  $:.unshift(File.join(dir, 'lib')) }
require 'rubycloud/linode'
require 'rubycloud/ec2'
