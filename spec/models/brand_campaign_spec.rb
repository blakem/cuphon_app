require 'spec_helper'

describe BrandCampaign do
  it "should be able to create" do
    BrandCampaign.create().should_not be_nil
  end
end
