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
  
  it "should be able to subscribe and unsubscribe to may brands at once" do
    brand1 = Factory(:brand)
    brand2 = Factory(:brand)
    brand3 = Factory(:brand)
    subscriber = Factory(:subscriber)
    subscriber.reload
    subscriber.subscribe!(brand1, brand2, brand3)
    subscriber.is_subscribed?(brand1).should be_true
    subscriber.is_subscribed?(brand2).should be_true
    subscriber.is_subscribed?(brand3).should be_true

    subscriber.unsubscribe!(brand1, brand2, brand3)
    subscriber.reload
    subscriber.is_subscribed?(brand1).should be_false
    subscriber.is_subscribed?(brand2).should be_false
    subscriber.is_subscribed?(brand3).should be_false
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

  it "is_subscribed?" do
    string = 'MonsterPow'
    subscriber = Factory(:subscriber)
    subscriber.is_subscribed?(string).should be_false
    
    subscriber.subscribe!(string)
    subscriber.reload
    subscriber.is_subscribed?(string).should be_true

    brand = Brand.find_by_title(string)
    subscriber.is_subscribed?(brand).should be_true
    
    subscriber.unsubscribe!(brand)
    subscriber.reload
    subscriber.is_subscribed?(brand).should be_false    
  end

  it "should unsubscribe from all brands on unsubscribe_all!" do
    brands = [Factory(:brand), Factory(:brand), Factory(:brand)]    
    subscriber = Factory(:subscriber)

    brands.each do |brand|
      subscriber.subscribe!(brand)
    end
    subscriber.unsubscribe_all!
    subscriber.reload
    brands.each do |brand|
      subscriber.is_subscribed?(brand).should be_false
    end
  end
  
  it "should get a new and unique device_id from the factory" do
    subscriber1 = Factory(:subscriber)
    subscriber2 = Factory(:subscriber)
    subscriber1.device_id.should_not == subscriber2.device_id
  end

  describe "default values" do
    it "should set type to 'sms' and active to true" do
      subscriber = Subscriber.create
      subscriber.active.should == 'true'
      subscriber.type.should == 'sms'

      subscriber.reload
      subscriber.active.should == 'true'
      subscriber.type.should == 'sms'
    end
  end
end
