require 'spec_helper'

describe BrandAlias do
  it "should be able to create" do
    BrandAlias.create().should_not be_nil
  end

  describe "canonicalize_alias" do
    it "should handle caps punctuation and spaces" do
      BrandAlias.canonicalize_alias('').should == ''
      BrandAlias.canonicalize_alias(nil).should == ''
      BrandAlias.canonicalize_alias('abc').should == 'abc'
      BrandAlias.canonicalize_alias('ABC').should == 'abc'
      BrandAlias.canonicalize_alias('  a  b   c    ').should == 'abc'
      BrandAlias.canonicalize_alias('a!!!B---c').should == 'abc'
    end
  end
end