require 'linode'

class RubyCloud::Linode
  attr_reader :api_key, :provider
  
  def initialize(args)
    raise ArgumentError, ':api_key is required' unless args[:api_key]
    @api_key = args[:api_key]
    @provider = Linode.new(:api_key => @api_key)
  end
  
  def list(args = {})
    provider.linode.list(args)
  end
  
  def allocate(args = {})
    provider.linode.create(args)
  end
  
  def details(args = {})
    raise ArgumentError, ":instance is required" unless args[:instance]
    list('LinodeID' => args[:instance])
  end
end
