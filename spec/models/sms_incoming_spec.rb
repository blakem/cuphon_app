require 'spec_helper'

describe SmsIncoming do
  it "should be able to create with a different table name" do
    SmsIncoming.create().should_not be_nil
  end
end
