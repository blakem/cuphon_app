require 'spec_helper'

describe BrandsInstant do
  it "should be able to create with the correct table" do
    BrandsInstant.create().should_not be_nil
  end
  
  it "should have a brand method that returns it's brand" do
    brand = Factory(:brand)
    instant = BrandsInstant.create(:brand_id => brand.id)
    instant.brand.should == brand    
  end
  
  it "factory should give it a brand" do
    instant = Factory(:brands_instant)
    instant.brand.id.should == instant.brand_id
  end
end
