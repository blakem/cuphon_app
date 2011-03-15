require 'spec_helper'

describe "Subscription" do
  it "should respond to brand" do
    brand = Brand.create(:title => 'FooFuFoo')
    subscription = Subscription.create(:brand_id => brand.id)
    subscription.brand.should == brand
  end

  it "should have a subscriber method" do
    subscriber = Factory(:subscriber)
    brand = Factory(:brand)
    subscription = Subscription.create(:device_id => subscriber.device_id, :brand_id => brand.id)
    subscription.subscriber.should == subscriber
  end
  
end
