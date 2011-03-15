require 'spec_helper'

describe QueuedMessage do
  it "should be able to create" do
    QueuedMessage.create().should_not be_nil
  end
  
  it "should have a subscriber" do
    subscriber = Factory(:subscriber)
    queued = QueuedMessage.create(:device_id => subscriber.device_id, :body => "Body", :priority => 2)
    queued.subscriber.should == subscriber
  end
end
