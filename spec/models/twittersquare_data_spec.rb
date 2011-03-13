require 'spec_helper'

describe TwittersquareData do
  it "should be able to create with the right table" do
    TwittersquareData.create().should_not be_nil
  end
end
