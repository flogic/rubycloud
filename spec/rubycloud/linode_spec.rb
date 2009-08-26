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
      lambda { @linode.list(:linode_id => @linode_id) }.should.not.raise(ArgumentError)
    end
    
    it 'should not require a linode id' do
      lambda { @linode.list }.should.not.raise(ArgumentError)
    end
    
    it 'should delegate to the stored provider' do
      @linode_api.should.receive(:list).with(:linode_id => @linode_id)
      @linode.list(:linode_id => @linode_id)
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
end
