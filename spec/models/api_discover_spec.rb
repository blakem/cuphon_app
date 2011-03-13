require 'spec_helper'

describe ApiDiscover do
  it "should work with odd table name" do
    ApiDiscover.create().should_not be_nil
  end
end
