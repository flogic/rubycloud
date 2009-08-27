class RubyCloud::Linode::Instance
  attr_reader :handle, :node

  def initialize(handle, node)
    @handle = handle
    @node = node
  end
  
  def details(options = {})
    handle.details({ :instance => node.linodeid }.merge(options))
  end

  def start(options = {})
    handle.start({ :instance => node.linodeid }.merge(options))
  end

  def stop(options = {})
    handle.stop({ :instance => node.linodeid }.merge(options))
  end

  def delete(options = {})
    handle.delete({ :instance => node.linodeid }.merge(options))
  end

  def restart(options = {})
    handle.restart({ :instance => node.linodeid }.merge(options))
  end
  
  def method_missing(meth, *args)
    raise NoMethodError, %Q{Linode API driver does not provide the method "#{meth}" on instances (more documentation available at:  http://www.linode.com/api/autodoc.cfm?method=linode.list).} unless node.respond_to?(meth)
    node.send(meth, *args)
  end
end