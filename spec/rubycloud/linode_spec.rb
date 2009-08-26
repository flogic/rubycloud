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
  end
end
