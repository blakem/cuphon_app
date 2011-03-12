require 'spec_helper'

describe Subscriber do
  it "should be able to subscribe! and unsubscribe!" do
    brand = Factory(:brand)
    subscriber = Factory(:subscriber)
    subscriber.subscribe!(brand)
    subscriber.brands.should include(brand)    
    subscriber.unsubscribe!(brand)
    subscriber.reload
    subscriber.brands.should_not include(brand)    

    subscriber.unsubscribe!(brand) # Don't crash when already unsubscribed
    subscriber.reload
    subscriber.brands.should_not include(brand)    
  end
  
  it "should be able to subscribe and unsubscribe with strings" do
    string = 'JiffyQuick'
    subscriber = Factory(:subscriber)
    subscriber.subscribe!(string)
    brand = Brand.find_by_title(string)
    subscriber.brands.should include(brand)

    subscriber.unsubscribe!(string)
    subscriber.reload
    subscriber.brands.should_not include(brand)
    
    subscriber.subscribe!(string)
    subscriber.reload
    subscriber.brands.should include(brand)
  end
  
  it "should not crash when unsubscribing to something that doesn't exist" do
    subscriber = Factory(:subscriber)
    subscriber.unsubscribe!('bunchofrandom stuff not there')
    subscriber.should_not be_nil
  end
end
