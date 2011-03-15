require 'spec_helper'

describe Brand do
  before(:each) do
    @valid = {
      :title => 'YummyPork',
      :featured => 'true',
      :instant => 'false',
      :active => 'true'
    }
  end
  
  describe "enum fields" do
    
    it "should create" do
      brand = Brand.create(@valid)
      brand.valid?.should be_true
      brand.title.should == 'YummyPork'
      brand.featured.should == 'true'
      brand.instant.should  == 'false'
      brand.active.should   == 'true'
    end
    
    it "should be findable" do
      Brand.create(@valid)
      Brand.find_by_title(@valid[:title]).should_not be_nil
      Brand.where(:featured => 'true').should_not be_nil
      Brand.where(:instant => 'false').should_not be_nil
      Brand.where(:active => 'true').should_not be_nil      
    end
  end

  describe "factory methods" do
    brand1 = Factory(:brand)
    brand2 = Factory(:brand)
    brand1.title.should_not == brand2.title
  end
  
  describe "merchant relationship" do
    it "with merchant" do
      @merchant =  Factory(:merchant)
      brand = Brand.create(@valid.merge({:merchant_id => @merchant.id}))
      brand.merchant.should == @merchant
      @merchant.brands.should == [brand]
    end

    it "without merchant" do
      brand = Brand.create(@valid)
      brand.merchant.should be_nil
    end 
  end

  describe "brands_instant relationship" do
    it "should have a brands_instant method" do
      instant = Factory(:brands_instant)
      brand = instant.brand
      brand.brands_instants.should include(instant)      
    end
    
    it "should have a has_active_instant method" do
      brand = Factory(:brand, :instant => "false")
      brand.instant?.should be_false
      brand.reload
      brand.instant?.should be_false      
      brand.has_active_instant?.should be_false
      
      BrandsInstant.create(:brand_id => brand.id)
      brand.has_active_instant?.should be_false

      brand.instant = "true"
      brand.has_active_instant?.should be_true      
      brand.save
      brand.reload
      brand.has_active_instant?.should be_true      
    end
  end
  
  describe "default values" do
    it "should set instant/featured/active to false" do
      brand = Brand.create
      brand.instant.should  == 'false'
      brand.active.should   == 'false'
      brand.featured.should == 'false'
      brand.in_app.should   == 'false'

      brand.reload
      brand.instant.should  == 'false'
      brand.active.should   == 'false'
      brand.featured.should == 'false'
      brand.in_app.should == 'false'
    end
  end

  describe "canonicalize title for brand" do
    it "should capitalize each word" do
      Brand.canonicalize_title('').should == ''
      Brand.canonicalize_title(nil).should == ''
      Brand.canonicalize_title('abc').should == 'Abc'
      Brand.canonicalize_title('ABC').should == 'ABC'
      Brand.canonicalize_title('  a  b   c    ').should == 'A B C'
      Brand.canonicalize_title('McDonalds TacoBell muffins').should == 'McDonalds TacoBell Muffins'
    end
  end
end
