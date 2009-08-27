if ENV['RUBYCLOUD_TEST_LINODE_API_KEY']

  require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper.rb]))

  describe RubyCloud::Linode do
    def clear_instances
      @rubycloud.list.each do |instance|
        instance.delete
      end
    end
    
    def create_instance
      datacenter = @rubycloud.driver.avail.datacenters.first.datacenterid
      plan = @rubycloud.driver.avail.linodeplans.first.planid
      payment = 1  # monthly
      @rubycloud.allocate('DatacenterID' => datacenter, 'PlanID' => plan, 'PaymentTerm' => payment)
    end
    
    def an_instance
      instances = @rubycloud.list
      return create_instance if instances.empty?
      instances.first
    end
    
    def create_config(instance)
      kernel = @rubycloud.driver.avail.kernels.first.kernelid
      @rubycloud.driver.linode.config.create('LinodeID' => instance.linodeid, 'KernelID' => kernel).configid
    end
    
    before do      
      @rubycloud = RubyCloud.new(:provider => 'linode', 
                                 :credentials => { 
                                   :api_key => ENV['RUBYCLOUD_TEST_LINODE_API_KEY'],
                                   :api_url => 'https://beta.linode.com/api'
                                 })
    end
    
    it 'should increase the instance count when allocating an instance' do
      before = @rubycloud.list.size
      datacenter = @rubycloud.driver.avail.datacenters.first.datacenterid
      plan = @rubycloud.driver.avail.linodeplans.first.planid
      payment = 1  # monthly
      @rubycloud.allocate('DatacenterID' => datacenter, 'PlanID' => plan, 'PaymentTerm' => payment)
      @rubycloud.list.size.should == (before + 1)
    end

    it 'should be able to list instances' do
      lambda { @rubycloud.list }.should.not.raise
    end
    
    if false
      #TODO FIXME PENDING:  these are waiting on beta.linode.com/api/ to not blow up when listing avail.kernels
      it 'should be able to start an instance' do
        instance = an_instance
        config = create_config(instance)
        instance.start('ConfigID' => config)
        lambda { instance.start }.should.not.raise
      end
    
      it 'should be able to restart an instance' do
        instance = an_instance
        config = create_config(instance)
        instance.restart('ConfigID' => config)
        lambda { instance.restart }.should.not.raise
      end
    end
    
    it 'should be able to stop an instance' do
      instance = an_instance
      lambda { instance.stop }.should.not.raise
    end
    
    it 'should be able to get the details for an instance' do
      instance = an_instance
      lambda { instance.details }.should.not.raise
    end
    
    it 'should decrease the instance count when deleting an instance' do      
      instance = an_instance
      before = @rubycloud.list.size
      instance.delete
      @rubycloud.list.size.should == (before - 1)      
    end
  end
end