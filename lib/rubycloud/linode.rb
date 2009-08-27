require 'linode'

class RubyCloud::Linode
  attr_reader :api_key, :driver
  
  def initialize(args)
    raise ArgumentError, ':api_key is required' unless args[:api_key]
    @api_key = args[:api_key]
    @driver = Linode.new(:api_key => @api_key)
  end
  
  def list(args = {})
    (driver.linode.list(args) || []).collect { |instance| RubyCloud::Linode::Instance.new(self, instance) }
  end
  
  def allocate(args = {})
    RubyCloud::Linode::Instance.new(self, driver.linode.create(args))
  end
  
  def details(args = {})
    raise ArgumentError, ":instance is required" unless args[:instance]
    args['LinodeID'] = args.delete(:instance)
    list(args)
  end
  
  def start(args = {})
    raise ArgumentError, ":instance is required" unless args[:instance]
    args['LinodeID'] = args.delete(:instance)
    driver.linode.boot(args)    
  end
  
  def stop(args = {})
    raise ArgumentError, ":instance is required" unless args[:instance]
    args['LinodeID'] = args.delete(:instance)
    driver.linode.shutdown(args)    
  end
  
  def delete(args = {})
    raise ArgumentError, ":instance is required" unless args[:instance]
    args['LinodeID'] = args.delete(:instance)
    driver.linode.delete(args)    
  end
  
  def restart(args = {})
    raise ArgumentError, ":instance is required" unless args[:instance]
    args['LinodeID'] = args.delete(:instance)
    driver.linode.reboot(args)    
  end
end
