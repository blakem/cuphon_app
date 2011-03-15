require 'spec_helper'

describe BrandsAlias do
  it "should be able to create" do
    BrandsAlias.create().should_not be_nil
  end

  describe "canonicalize_alias" do
    it "should handle caps punctuation and spaces" do
      BrandsAlias.canonicalize_alias('').should == ''
      BrandsAlias.canonicalize_alias(nil).should == ''
      BrandsAlias.canonicalize_alias('abc').should == 'abc'
      BrandsAlias.canonicalize_alias('ABC').should == 'abc'
      BrandsAlias.canonicalize_alias('  a  b   c    ').should == 'abc'
      BrandsAlias.canonicalize_alias('a!!!B---c').should == 'abc'
    end
  end
end