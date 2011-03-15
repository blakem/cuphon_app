require 'spec_helper'

describe Merchant do
  it "should work with the database" do
    merchant = Merchant.create(
      :name => 'Happy',
      :email => 'foobar@baz.com'
    )
    merchant.email.should == 'foobar@baz.com'
  end
  it "should be able to create" do
    Merchant.create().should_not be_nil
  end
  
  describe "Data integrity" do
    it "should destroy its brands on deletion" do
      merchant = Factory(:merchant)
      brand = Factory(:brand, :merchant_id => merchant.id)
      merchant.brands.should include(brand)
      brand.merchant.should == merchant
      merchant.destroy
      Brand.find_by_id(brand.id).should be_nil
    end
  end
end
