require 'spec_helper'

describe BrandsCampaign do
  it "should be able to create" do
    BrandsCampaign.create().should_not be_nil
  end
end
