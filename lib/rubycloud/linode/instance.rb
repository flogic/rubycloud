class RubyCloud::Linode::Instance
  attr_reader :handle, :instance

  def initialize(handle, instance)
    @handle = handle
    @instance = instance
  end
  
  def details(options = {})
    handle.details({ :instance => instance.linodeid }.merge(options))
  end

  def start(options = {})
    handle.start({ :instance => instance.linodeid }.merge(options))
  end

  def stop(options = {})
    handle.stop({ :instance => instance.linodeid }.merge(options))
  end

  def delete(options = {})
    handle.delete({ :instance => instance.linodeid }.merge(options))
  end

  def restart(options = {})
    handle.restart({ :instance => instance.linodeid }.merge(options))
  end
end