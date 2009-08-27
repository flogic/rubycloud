require File.expand_path(File.join(File.dirname(__FILE__), %w[.. .. spec_helper.rb]))

describe RubyCloud::Linode::Instance, '.new' do
  it 'should allow a RubyCloud::Linode handle and an instance argument' do
    lambda { RubyCloud::Linode::Instance.new(:handle, :instance) }.should.not.raise(ArgumentError)
  end
  
  it 'should require a RubyCloud::Linode handle and an instance argument' do
    lambda { RubyCloud::Linode::Instance.new(:handle) }.should.raise(ArgumentError)    
  end
  
  it 'should store the RubyCloud::Linode handle' do
    RubyCloud::Linode::Instance.new(:handle, :instance).handle.should == :handle
  end
  
  it 'should store the instance' do
    RubyCloud::Linode::Instance.new(:handle, :instance).instance.should == :instance
  end
end

describe RubyCloud::Linode::Instance, 'when instantiated' do
  before do
    @handle = Object.new
    @result_instance = Object.new
    @result_instance.stub!(:linodeid).and_return(12345)
    @instance = RubyCloud::Linode::Instance.new(@handle, @result_instance)
  end
  
  it 'should allow fetching details for this instance' do
    @instance.should.respond_to(:details)
  end
  
  describe 'when fetching details' do
    before do
      @handle.stub!(:details)
    end
    
    it 'should accept a hash of arguments' do
      lambda { @instance.details(:foo => :bar)}.should.not.raise(ArgumentError)
    end
    
    it 'should work without arguments' do
      lambda { @instance.details }.should.not.raise(ArgumentError)      
    end
    
    it "should call the details method on its handle" do
      @handle.should.receive(:details)
      @instance.details
    end
    
    it "should pass the instance's id to the handle when calling details" do
      @handle.should.receive(:details).with(:instance => @result_instance.linodeid)
      @instance.details
    end

    it 'should pass along any additional details when calling details on the handle' do
      @handle.should.receive(:details).with(:instance => @result_instance.linodeid, 'foo' => 'bar')
      @instance.details('foo' => 'bar')
    end
        
    it "should return the result of calling details on the handle" do
      details_results = Object.new
      @handle.should.receive(:details).with(:instance => @result_instance.linodeid, 'foo' => 'bar').and_return(details_results)
      @instance.details('foo' => 'bar').should == details_results
    end
  end

  it 'should allow calling start for this instance' do
    @instance.should.respond_to(:start)
  end
  
  describe 'when calling start' do
    before do
      @handle.stub!(:start)
    end
    
    it 'should accept a hash of arguments' do
      lambda { @instance.start(:foo => :bar)}.should.not.raise(ArgumentError)
    end
    
    it 'should work without arguments' do
      lambda { @instance.start }.should.not.raise(ArgumentError)      
    end
    
    it "should call the start method on its handle" do
      @handle.should.receive(:start)
      @instance.start
    end
    
    it "should pass the instance's id to the handle when calling start" do
      @handle.should.receive(:start).with(:instance => @result_instance.linodeid)
      @instance.start
    end

    it 'should pass along any additional arguments when calling start on the handle' do
      @handle.should.receive(:start).with(:instance => @result_instance.linodeid, 'foo' => 'bar')
      @instance.start('foo' => 'bar')
    end
        
    it "should return the result of calling start on the handle" do
      start_results = Object.new
      @handle.should.receive(:start).with(:instance => @result_instance.linodeid, 'foo' => 'bar').and_return(start_results)
      @instance.start('foo' => 'bar').should == start_results
    end
  end

  it 'should allow calling stop for this instance' do
    @instance.should.respond_to(:stop)
  end
  
  describe 'when calling stop' do
    before do
      @handle.stub!(:stop)
    end
    
    it 'should accept a hash of arguments' do
      lambda { @instance.stop(:foo => :bar)}.should.not.raise(ArgumentError)
    end
    
    it 'should work without arguments' do
      lambda { @instance.stop }.should.not.raise(ArgumentError)      
    end
    
    it "should call the stop method on its handle" do
      @handle.should.receive(:stop)
      @instance.stop
    end
    
    it "should pass the instance's id to the handle when calling stop" do
      @handle.should.receive(:stop).with(:instance => @result_instance.linodeid)
      @instance.stop
    end

    it 'should pass along any additional arguments when calling stop on the handle' do
      @handle.should.receive(:stop).with(:instance => @result_instance.linodeid, 'foo' => 'bar')
      @instance.stop('foo' => 'bar')
    end
        
    it "should return the result of calling stop on the handle" do
      stop_results = Object.new
      @handle.should.receive(:stop).with(:instance => @result_instance.linodeid, 'foo' => 'bar').and_return(stop_results)
      @instance.stop('foo' => 'bar').should == stop_results
    end
  end
  
  it 'should allow calling delete for this instance' do
    @instance.should.respond_to(:delete)
  end
  
  describe 'when calling delete' do
    before do
      @handle.stub!(:delete)
    end
    
    it 'should accept a hash of arguments' do
      lambda { @instance.delete(:foo => :bar)}.should.not.raise(ArgumentError)
    end
    
    it 'should work without arguments' do
      lambda { @instance.delete }.should.not.raise(ArgumentError)      
    end
    
    it "should call the delete method on its handle" do
      @handle.should.receive(:delete)
      @instance.delete
    end
    
    it "should pass the instance's id to the handle when calling delete" do
      @handle.should.receive(:delete).with(:instance => @result_instance.linodeid)
      @instance.delete
    end

    it 'should pass along any additional arguments when calling delete on the handle' do
      @handle.should.receive(:delete).with(:instance => @result_instance.linodeid, 'foo' => 'bar')
      @instance.delete('foo' => 'bar')
    end
        
    it "should return the result of calling delete on the handle" do
      delete_results = Object.new
      @handle.should.receive(:delete).with(:instance => @result_instance.linodeid, 'foo' => 'bar').and_return(delete_results)
      @instance.delete('foo' => 'bar').should == delete_results
    end
  end
  
  it 'should allow calling restart for this instance' do
    @instance.should.respond_to(:restart)
  end
  
  describe 'when calling restart' do
    before do
      @handle.stub!(:restart)
    end
    
    it 'should accept a hash of arguments' do
      lambda { @instance.restart(:foo => :bar)}.should.not.raise(ArgumentError)
    end
    
    it 'should work without arguments' do
      lambda { @instance.restart }.should.not.raise(ArgumentError)      
    end
    
    it "should call the restart method on its handle" do
      @handle.should.receive(:restart)
      @instance.restart
    end
    
    it "should pass the instance's id to the handle when calling restart" do
      @handle.should.receive(:restart).with(:instance => @result_instance.linodeid)
      @instance.restart
    end

    it 'should pass along any additional arguments when calling restart on the handle' do
      @handle.should.receive(:restart).with(:instance => @result_instance.linodeid, 'foo' => 'bar')
      @instance.restart('foo' => 'bar')
    end
        
    it "should return the result of calling restart on the handle" do
      restart_results = Object.new
      @handle.should.receive(:restart).with(:instance => @result_instance.linodeid, 'foo' => 'bar').and_return(restart_results)
      @instance.restart('foo' => 'bar').should == restart_results
    end
  end
end
