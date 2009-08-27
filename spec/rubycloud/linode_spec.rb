require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper.rb]))

describe RubyCloud::Linode do
  describe 'when instantiated' do
    before do
      @api_key = '1203498asdflk'
    end
    
    it 'should accept hash arguments' do
      lambda { RubyCloud::Linode.new(:api_key => @api_key) }.should.not.raise(ArgumentError)
    end
    
    it 'should require hash arguments' do
      lambda { RubyCloud::Linode.new }.should.raise(ArgumentError)
    end
    
    it 'should require the API key to be part of the arguments' do
      lambda { RubyCloud::Linode.new(:poop => true) }.should.raise(ArgumentError)
    end
    
    it 'should store the API key' do
      RubyCloud::Linode.new(:api_key => @api_key).api_key.should == @api_key
    end
    
    it 'should create a driver' do
      RubyCloud::Linode.new(:api_key => @api_key).driver.should.be.instance_of(::Linode)
    end
    
    it 'should use the given API key for the stored driver' do
      RubyCloud::Linode.new(:api_key => @api_key).driver.api_key.should == @api_key
    end
    
    it 'should pass any other arguments when initializing the stored driver' do
      Linode.should.receive(:new).with(:api_key => @api_key, :foo => :bar)
      RubyCloud::Linode.new(:api_key => @api_key, :foo => :bar)
    end
  end
  
  before do
    @api_key = 'some_secret_key'
    @linode = RubyCloud::Linode.new(:api_key => @api_key)
  end
  
  it 'should list instances' do
    @linode.should.respond_to(:list)
  end
  
  describe 'listing instances' do
    before do
      # this is done in the driver's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:list)
      @linode.driver.stub!(:linode).and_return(@linode_api)
      @linode_id = 5
    end
    
    it 'should accept a linode id' do
      lambda { @linode.list('LinodeID' => @linode_id) }.should.not.raise(ArgumentError)
    end
    
    it 'should not require a linode id' do
      lambda { @linode.list }.should.not.raise(ArgumentError)
    end
    
    it 'should delegate to the stored driver' do
      @linode_api.should.receive(:list).with('LinodeID' => @linode_id)
      @linode.list('LinodeID' => @linode_id)
    end
    
    it 'should pass an empty hash to the stored driver if no linode_id given' do
      @linode_api.should.receive(:list).with({})
      @linode.list
    end
    
    it 'should create a new linode instance from each element of the driver list results' do
      list_data = [ '1', '2', '3' ]
      @linode_api.stub!(:list).and_return(list_data)
      list_data.each do |element|
        RubyCloud::Linode::Instance.should.receive(:new).with(@linode, element)
      end
      @linode.list
    end
    
    it 'should return the list of linode instances created from driver list results' do
      list_data = [ '1', '2', '3' ]
      @linode_api.stub!(:list).and_return(list_data)
      results = []
      list_data.each do |element|
        instance = Object.new
        results << instance
        RubyCloud::Linode::Instance.should.receive(:new).with(@linode, element).and_return(instance)
      end
      @linode.list.should == results
    end
  end
  
  it 'should be able to allocate an instance' do
    @linode.should.respond_to(:allocate)
  end
  
  describe 'allocating an instance' do
    before do
      # this is done in the driver's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:create)
      @linode.driver.stub!(:linode).and_return(@linode_api)
    end
    
    it 'should accept hash arguments' do
      lambda { @linode.allocate(:one => 2) }.should.not.raise(ArgumentError)
    end
    
    it 'should not require hash arguments' do
      lambda { @linode.allocate }.should.not.raise(ArgumentError)
    end
    
    it 'should delegate to the stored driver' do
      args = { :a => 'bee', :c => 0x0d }
      @linode_api.should.receive(:create).with(args)
      @linode.allocate(args)
    end
    
    it 'should pass an empty hash to the stored driver if no arguments given' do
      @linode_api.should.receive(:create).with({})
      @linode.allocate
    end
    
    it 'should create a new linode instance from the driver create result' do
      create_data = 'create data'
      @linode_api.stub!(:create).and_return(create_data)
      linode_instance = Object.new
      RubyCloud::Linode::Instance.should.receive(:new).with(@linode, create_data).and_return(linode_instance)
      @linode.allocate
    end

    it 'should return the newly created linode instance' do
      create_data = 'create data'
      @linode_api.stub!(:create).and_return(create_data)
      linode_instance = Object.new
      RubyCloud::Linode::Instance.stub!(:new).with(@linode, create_data).and_return(linode_instance)
      @linode.allocate.should == linode_instance      
    end
  end
  
  it 'should be able to get details for an instance' do
    @linode.should.respond_to(:details)
  end
  
  describe 'getting details for an instance' do
    before do
      @linode.stub!(:list)
    end
    
    it 'should accept an instance ID' do
      lambda { @linode.details(:instance => 5) }.should.not.raise(ArgumentError)
    end
    
    it 'should require an instance ID' do
      lambda { @linode.details }.should.raise(ArgumentError)
    end
    
    it 'should delegate to the list for the given linode ID' do
      linode_id = 38
      @linode.should.receive(:list).with('LinodeID' => linode_id)
      @linode.details(:instance => linode_id)
    end

    it 'should include any additional arguments when calling list' do
      linode_id = 38
      @linode.should.receive(:list).with('LinodeID' => linode_id, 'foo' => 'bar')
      @linode.details(:instance => linode_id, 'foo' => 'bar')
    end
    
    it 'should return the list result' do
      details_data = 'details data'
      @linode.stub!(:list).and_return(details_data)
      @linode.details(:instance => 123).should == details_data
    end
  end
  
  it 'should be able to start an instance' do
    @linode.should.respond_to(:start)
  end
  
  describe 'starting an instance' do
    before do
      # this is done in the driver's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:boot)
      @linode.driver.stub!(:linode).and_return(@linode_api)
    end
    
    it 'should accept an instance ID' do
      lambda { @linode.start(:instance => 5) }.should.not.raise(ArgumentError)
    end
    
    it 'should require an instance ID' do
      lambda { @linode.start }.should.raise(ArgumentError)
    end
    
    it 'should delegate to the boot for the given linode ID' do
      linode_id = 38
      @linode_api.should.receive(:boot).with('LinodeID' => linode_id)
      @linode.start(:instance => linode_id)
    end
    
    it 'should include any additional arguments when calling boot' do
      linode_id = 38
      @linode_api.should.receive(:boot).with('LinodeID' => linode_id, 'foo' => 'bar')
      @linode.start(:instance => linode_id, 'foo' => 'bar')      
    end
    
    it 'should return the boot result' do
      boot_data = 'boot data'
      @linode_api.stub!(:boot).and_return(boot_data)
      @linode.start(:instance => 123).should == boot_data
    end
  end
  
  it 'should be able to stop an instance' do
    @linode.should.respond_to(:stop)
  end
  
  describe 'stopping an instance' do
    before do
      # this is done in the driver's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:shutdown)
      @linode.driver.stub!(:linode).and_return(@linode_api)
    end
    
    it 'should accept an instance ID' do
      lambda { @linode.stop(:instance => 5) }.should.not.raise(ArgumentError)
    end
    
    it 'should require an instance ID' do
      lambda { @linode.stop }.should.raise(ArgumentError)
    end
    
    it 'should delegate to the shutdown for the given linode ID' do
      linode_id = 38
      @linode_api.should.receive(:shutdown).with('LinodeID' => linode_id)
      @linode.stop(:instance => linode_id)
    end
    
    it 'should include any additional arguments when calling shutdown' do
      linode_id = 38
      @linode_api.should.receive(:shutdown).with('LinodeID' => linode_id, 'foo' => 'bar')
      @linode.stop(:instance => linode_id, 'foo' => 'bar')      
    end
    
    it 'should return the shutdown result' do
      shutdown_data = 'shutdown data'
      @linode_api.stub!(:shutdown).and_return(shutdown_data)
      @linode.stop(:instance => 123).should == shutdown_data
    end
  end
  
  it 'should be able to delete an instance' do
    @linode.should.respond_to(:delete)
  end
  
  describe 'deleting an instance' do
    before do
      # this is done in the driver's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:delete)
      @linode.driver.stub!(:linode).and_return(@linode_api)
    end
    
    it 'should accept an instance ID' do
      lambda { @linode.delete(:instance => 5) }.should.not.raise(ArgumentError)
    end
    
    it 'should require an instance ID' do
      lambda { @linode.delete }.should.raise(ArgumentError)
    end
    
    it 'should delegate to the delete for the given linode ID' do
      linode_id = 38
      @linode_api.should.receive(:delete).with('LinodeID' => linode_id)
      @linode.delete(:instance => linode_id)
    end
    
    it 'should include any additional arguments when calling delete' do
      linode_id = 38
      @linode_api.should.receive(:delete).with('LinodeID' => linode_id, 'foo' => 'bar')
      @linode.delete(:instance => linode_id, 'foo' => 'bar')      
    end
    
    it 'should return the delete result' do
      delete_data = 'delete data'
      @linode_api.stub!(:delete).and_return(delete_data)
      @linode.delete(:instance => 123).should == delete_data
    end
  end
  
  it 'should be able to restart an instance' do
    @linode.should.respond_to(:restart)
  end
  
  describe 'restarting an instance' do
    before do
      # this is done in the driver's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:reboot)
      @linode.driver.stub!(:linode).and_return(@linode_api)
    end
    
    it 'should accept an instance ID' do
      lambda { @linode.restart(:instance => 5) }.should.not.raise(ArgumentError)
    end
    
    it 'should require an instance ID' do
      lambda { @linode.restart }.should.raise(ArgumentError)
    end
    
    it 'should delegate to the reboot for the given linode ID' do
      linode_id = 38
      @linode_api.should.receive(:reboot).with('LinodeID' => linode_id)
      @linode.restart(:instance => linode_id)
    end
    
    it 'should include any additional arguments when calling reboot' do
      linode_id = 38
      @linode_api.should.receive(:reboot).with('LinodeID' => linode_id, 'foo' => 'bar')
      @linode.restart(:instance => linode_id, 'foo' => 'bar')      
    end
    
    it 'should return the reboot result' do
      reboot_data = 'reboot data'
      @linode_api.stub!(:reboot).and_return(reboot_data)
      @linode.restart(:instance => 123).should == reboot_data
    end
  end
end
