require 'spec_helper'

describe Brand do
  before(:each) do
    @valid = {
      :title => 'YummyPork',
      :featured => 'true',
      :instant => 'false',
      :active => 'true',
      :in_app => 'false'
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
      brand.in_app.should == 'false'
    end
    
    it "should be findable" do
      Brand.create(@valid)
      Brand.find_by_title(@valid[:title]).should_not be_nil
      Brand.where(:featured => 'true').should_not be_nil
      Brand.where(:instant => 'false').should_not be_nil
      Brand.where(:active => 'true').should_not be_nil      
    end
  end
  
  describe "get_or_create" do
    it "should get a brand that already exists" do
      brand1 = Factory(:brand)
      brand2 = Brand.get_or_create(brand1.title)
      brand2.should == brand1
    end

    it "should create one if it doesn't already exist" do
      brand1 = Brand.get_or_create('get_or_create_test')
      brand2 = Brand.find_by_title('get_or_create_test')
      brand1.should == brand2
      brand1.in_app?.should be_true
      brand1.active?.should be_false
      brand1.featured?.should be_false
      brand1.instant?.should be_false
      brand1.national?.should be_false
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
  
  describe "brand_aliases relationship" do
    it "should have many brand_aliases" do
      brand = Factory(:brand)
      brand_alias1 = Factory(:brand_alias, :brand_id => brand.id)
      brand_alias2 = Factory(:brand_alias, :brand_id => brand.id)
      brand_alias3 = Factory(:brand_alias)
      brand.brand_aliases.should include(brand_alias1)
      brand.brand_aliases.should include(brand_alias2)
      brand.brand_aliases.should_not include(brand_alias3)
    
      brand_alias1.brand.should == brand
    end
  end

  describe "brands_instant relationship" do
    it "should have a brands_instant method" do
      instant = Factory(:brand_instant)
      brand = instant.brand
      brand.brand_instants.should include(instant)      
    end
    
    it "should have a has_active_instant method" do
      brand = Factory(:brand, :instant => "false")
      brand.instant?.should be_false
      brand.reload
      brand.instant?.should be_false      
      brand.has_active_instant?.should be_false
      
      BrandInstant.create(:brand_id => brand.id)
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
  
  describe "Data integrity" do
    it "should destroy its subscriptions on deletion" do
      subscriber = Factory(:subscriber)
      brand = Factory(:brand)
      subscriber.subscribe!(brand)
      subscription = Subscription.find_by_device_id_and_brand_id(subscriber.device_id, brand.id)
      subscription.brand_id.should == brand.id
      brand.destroy
      Subscription.find_by_id(subscription.id).should be_nil
    end

    it "should destroy its brand_instants on deletion" do
      brand = Factory(:brand)
      instant = Factory(:brand_instant, :brand_id => brand.id)
      brand.destroy
      BrandInstant.find_by_brand_id(brand.id).should be_nil
    end

    it "should destroy its brand_alias on deletion" do
      brand = Factory(:brand)
      brand_alias = Factory(:brand_alias, :brand_id => brand.id)
      brand.destroy
      BrandAlias.find_by_brand_id(brand.id).should be_nil
    end

  end
  
  describe "flags" do
    brand = Factory(:brand)
    brand.featured = 'true'
    brand.in_app = 'true'
    brand.active = 'true'
    brand.flags.should == 'active, featured, in_app'
    
    brand.in_app = 'false'
    brand.flags.should == 'active, featured'

    brand.featured = 'false'
    brand.in_app = 'true'
    brand.active = 'false'
    brand.flags.should == 'in_app'
  end
end
