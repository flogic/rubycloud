class RubyCloud
  def initialize(options)
    raise ArgumentError unless options[:provider] and options[:credentials]
    # RubyCloud::EC2.new(options[:credentials])
  end
end

require 'rubycloud/linode'
