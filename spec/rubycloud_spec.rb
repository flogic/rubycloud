require File.dirname(__FILE__) + '/spec_helper.rb'

describe RubyCloud, '.new' do
  before do
    RubyCloud::EC2.stub!(:new)
  end
  
  it 'should accept :provider and :credentials' do
    lambda { RubyCloud.new(:provider => 'ec2', 
                           :credentials => {}) }.should.not.raise(ArgumentError)
  end

  it 'should complain if no :provider given' do
    lambda { RubyCloud.new(:credentials => {}) }.should.raise(ArgumentError)
  end

  it 'should complain if no :credentials given' do
    lambda { RubyCloud.new(:provider => 'ec2') }.should.raise(ArgumentError)
  end

  it 'should instantiate the requested provider' do
    RubyCloud::EC2.should.receive(:new).with({})  
    RubyCloud.new(:provider => 'ec2', :credentials => {})
  end
  
  it 'should return the requested provider instance' do
    instance = Object.new
    RubyCloud::EC2.stub!(:new).and_return(instance)
    RubyCloud.new(:provider => 'ec2', :credentials => {}).should == instance
  end

  it 'should try to instantiate any given provider' do
    RubyCloud.const_set('PwnedFauxProvider', 'xxx')
    RubyCloud::PwnedFauxProvider.should.receive(:new)
    RubyCloud.new(:provider => 'pwned_faux_provider', :credentials => {})
    RubyCloud.send(:remove_const, "PwnedFauxProvider")
  end

  it 'should complain if provider does not exist' do
    lambda { RubyCloud.new(:provider => 'pwned_faux_provider', :credentials => {}) }.should.raise InvalidProviderError
  end
  
end
