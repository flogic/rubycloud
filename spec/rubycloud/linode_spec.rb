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
    
    it 'should create a provider' do
      RubyCloud::Linode.new(:api_key => @api_key).provider.should.be.instance_of(::Linode)
    end
    
    it 'should use the given API key for the stored provider' do
      RubyCloud::Linode.new(:api_key => @api_key).provider.api_key.should == @api_key
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
      # this is done in the provider's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:list)
      @linode.provider.stub!(:linode).and_return(@linode_api)
      @linode_id = 5
    end
    
    it 'should accept a linode id' do
      lambda { @linode.list('LinodeID' => @linode_id) }.should.not.raise(ArgumentError)
    end
    
    it 'should not require a linode id' do
      lambda { @linode.list }.should.not.raise(ArgumentError)
    end
    
    it 'should delegate to the stored provider' do
      @linode_api.should.receive(:list).with('LinodeID' => @linode_id)
      @linode.list('LinodeID' => @linode_id)
    end
    
    it 'should pass an empty hash to the stored provider if no linode_id given' do
      @linode_api.should.receive(:list).with({})
      @linode.list
    end
    
    it 'should return the provider list result' do
      list_data = 'list data'
      @linode_api.stub!(:list).and_return(list_data)
      @linode.list.should == list_data
    end
  end
  
  it 'should be able to allocate an instance' do
    @linode.should.respond_to(:allocate)
  end
  
  describe 'allocating an instance' do
    before do
      # this is done in the provider's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:create)
      @linode.provider.stub!(:linode).and_return(@linode_api)
    end
    
    it 'should accept hash arguments' do
      lambda { @linode.allocate(:one => 2) }.should.not.raise(ArgumentError)
    end
    
    it 'should not require hash arguments' do
      lambda { @linode.allocate }.should.not.raise(ArgumentError)
    end
    
    it 'should delegate to the stored provider' do
      args = { :a => 'bee', :c => 0x0d }
      @linode_api.should.receive(:create).with(args)
      @linode.allocate(args)
    end
    
    it 'should pass an empty hash to the stored provider if no arguments given' do
      @linode_api.should.receive(:create).with({})
      @linode.allocate
    end
    
    it 'should return the provider create result' do
      create_data = 'create data'
      @linode_api.stub!(:create).and_return(create_data)
      @linode.allocate.should == create_data
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
      # this is done in the provider's "linode" namespace
      @linode_api = Object.new
      @linode_api.stub!(:boot)
      @linode.provider.stub!(:linode).and_return(@linode_api)
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
end
