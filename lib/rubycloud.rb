class InvalidProviderError < ArgumentError; end

module RubyCloud
  class << self
    def new(options)
      raise ArgumentError unless options[:provider] and options[:credentials]
      modularize_provider_string(options[:provider]).new(options[:credentials])
    end
    
  private
    def modularize_provider_string(str)
      RubyCloud.const_get(RubyCloud.constants.find{|c| c.upcase == str.gsub('_', '').upcase})
    rescue TypeError
      raise InvalidProviderError
    end
  end
end

Dir['vendor/*'].each { |dir|  $:.unshift(File.join(dir, 'lib')) }
require 'rubycloud/linode'
require 'rubycloud/ec2'
