require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper.rb]))

describe RubyCloud::EC2 do
  describe 'when instantiated' do
    it 'should accept hash arguments' do
      lambda { RubyCloud::EC2.new(:access_key_id => 'c0ffee', 
                                  :secret_access_key => 'beef99') }.should.not.raise(ArgumentError)
    end
    
    it 'should require hash arguments' do
      lambda { RubyCloud::EC2.new() }.should.raise(ArgumentError)
    end
    
    it 'should require the access_key_id to be part of the arguments' do
      lambda { RubyCloud::EC2.new(:secret_access_key => 'beef99') }.should.raise(ArgumentError)
    end

    it 'should require the secret_access_key to be part of the arguments' do
      lambda { RubyCloud::EC2.new(:access_key_id => 'c0ffee') }.should.raise(ArgumentError)
    end

    it 'should store the access key id' do
      @access_key_id = 'c0ffee'
      RubyCloud::EC2.new(:access_key_id => @access_key_id, 
                         :secret_access_key => 'beef99').access_key_id.should == @access_key_id
    end

    it 'should store the secret access key' do
      @secret_access_key = 'beef99'
      RubyCloud::EC2.new(:access_key_id => 'c0ffee', 
                         :secret_access_key => @secret_access_key).secret_access_key.should == @secret_access_key
    end
    
    it 'should create a driver' do
      RubyCloud::EC2.new(:access_key_id => 'c0ffee', 
                         :secret_access_key => 'beef99').driver.should.be.instance_of(::AWS::EC2::Base)
    end
    
    it 'should use the given credentials when instantiating the EC2 driver' do
      @credentials = { :access_key_id => 'c0ffee', :secret_access_key => 'beef99' }
      AWS::EC2::Base.should.receive(:new).with(@credentials)
      RubyCloud::EC2.new(@credentials)
    end
  end
end
