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
end
