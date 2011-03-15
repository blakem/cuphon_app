require 'spec_helper'

describe ApiDiscover do
  it "should work with odd table name" do
    ApiDiscover.create().should_not be_nil
  end

  describe "default values" do
    it "should set instant/featured to false" do
      apidiscover = ApiDiscover.create
      apidiscover.instant.should  == 'false'
      apidiscover.featured.should == 'false'

      apidiscover.reload
      apidiscover.instant.should  == 'false'
      apidiscover.featured.should == 'false'
    end
  end
end
