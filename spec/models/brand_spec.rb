require 'spec_helper'

describe Brand do
  describe "enum fields" do
    before(:each) do
      @valid = {
        :title => 'YummyPork',
        :featured => true,
        :instant => false,
        :active => true
      }
    end
    
    it "should create" do
      brand = Brand.create(@valid)
      brand.valid?.should be_true
      brand.title.should == 'YummyPork'      
    end
  end
end
