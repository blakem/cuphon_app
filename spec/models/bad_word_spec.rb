require 'spec_helper'

describe BadWord do
  it "should be able to create" do
    BadWord.create().should_not be_nil
  end
end
