require 'aws'

class RubyCloud::EC2
  attr_accessor :access_key_id, :secret_access_key, :driver
  
  def initialize(options)
    raise ArgumentError, ':access_key_id is required' unless options[:access_key_id]
    raise ArgumentError, ':secret_access_key is required' unless options[:secret_access_key]
    @access_key_id, @secret_access_key = options[:access_key_id], options[:secret_access_key]
    @driver = AWS::EC2::Base.new(options)
  end
  
  def list(options={})
    driver_options = {}
    driver_options[:instance_id] = Array(options[:instance]) if options[:instance]
    driver.describe_instances(driver_options)
  end
  
  def allocate(options={})
    driver.run_instances(options)
  end
end
