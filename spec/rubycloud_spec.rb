require File.dirname(__FILE__) + '/spec_helper.rb'

describe RubyCloud, '.new' do
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

  # it 'should instantiate the requested provider' do
  #   @ec2_provider = mock('EC2 Provider')
  #   @ec2_provider.should.receive(:new).with({})
  # 
  #   RubyCloud.new(:provider => 'ec2', :credentials => {})
  # end

  # it 'should return an instance of the requested provider' do
  # end

end
