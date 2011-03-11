require 'spec_helper'

describe Merchant do
  it "should work with the database" do
    merchant = Merchant.create(
      :name => 'Happy',
      :email => 'foobar@baz.com'
    )
    merchant.email.should == 'foobar@baz.com'
  end
end
