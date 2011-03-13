require 'spec_helper'

describe ApiCuphon do
  it "should be able to create" do
    ApiCuphon.create().should_not be_nil
  end
end