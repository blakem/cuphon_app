require 'spec_helper'

describe BrandsInstant do
  it "should be able to create with the correct table" do
    BrandsInstant.create().should_not be_nil
  end
end
