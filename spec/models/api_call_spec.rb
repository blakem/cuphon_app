require 'spec_helper'

describe ApiCall do
  it "should be able to create" do
    ApiCall.create().should_not be_nil
  end
end