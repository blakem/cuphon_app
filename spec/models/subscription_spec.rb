require 'spec_helper'

describe "Subscription" do
  it "should respond to brand" do
    brand = Brand.create(:title => 'FooFuFoo')
    subscription = Subscription.create(:brand_id => brand.id)
    subscription.brand.should == brand
  end
  
end
