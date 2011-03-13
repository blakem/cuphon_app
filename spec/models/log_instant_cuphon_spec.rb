require 'spec_helper'

describe LogInstantCuphon do
  it "should be able to create" do
    LogInstantCuphon.create().should_not be_nil
  end
end
