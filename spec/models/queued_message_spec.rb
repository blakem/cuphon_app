require 'spec_helper'

describe QueuedMessage do
  it "should be able to create" do
    QueuedMessage.create().should_not be_nil
  end
end
