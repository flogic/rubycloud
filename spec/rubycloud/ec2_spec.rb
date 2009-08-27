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
  
  it 'should list instances' do
    RubyCloud::EC2.new(:access_key_id => 'c0ffee', 
                       :secret_access_key => 'beef99').should.respond_to(:list)
  end
  
  describe 'listing instances' do
    before do
      # this is done in the driver's "aws::ec2" namespace
      @ec2_api = Object.new
      @ec2_api.stub!(:describe_instances)
      
      @ec2 = RubyCloud::EC2.new(:access_key_id => 'c0ffee', 
                                :secret_access_key => 'beef99')
      @ec2.stub!(:driver).and_return(@ec2_api)
    end
    
    it 'should accept hash argument with instance' do
      lambda { @ec2.list(:instance => 'foo') }.should.not.raise(ArgumentError)
    end
    
    it 'should not require arguments' do
      lambda { @ec2.list() }.should.not.raise(ArgumentError)
    end
    
    it 'should delegate to the driver correctly when no arguments provided' do
      @ec2.driver.should.receive(:describe_instances).with({})
      @ec2.list()
    end
    
    it 'should delegate to the driver correctly when one instance id provided' do
      @actual_args = {:instance => 1}
      @expected_args = {:instance_id => [1]}
      @ec2.driver.should.receive(:describe_instances).with(@expected_args)
      @ec2.list(@actual_args)
    end

    it 'should delegate to the driver correctly when multiple instance ids provided' do
      @actual_args = {:instance => [1, 2, 3]}
      @expected_args = {:instance_id => [1, 2, 3]}
      @ec2.driver.should.receive(:describe_instances).with(@expected_args)
      @ec2.list(@actual_args)
    end
    
    it 'should return the driver list result' do
      list_data = 'list data'
      @ec2_api.stub!(:describe_instances).and_return(list_data)
      @ec2.list.should == list_data
    end
  end
  
end
