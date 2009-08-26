require 'linode'

class RubyCloud::Linode
  attr_reader :api_key, :provider
  
  def initialize(args)
    raise ArgumentError, ':api_key is required' unless args[:api_key]
    @api_key = args[:api_key]
    @provider = Linode.new(:api_key => @api_key)
  end
  
  def list
    provider.linode.list
  end
end
