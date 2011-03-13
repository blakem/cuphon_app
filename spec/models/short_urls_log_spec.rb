require 'spec_helper'

describe ShortUrlsLog do
  it "should be able to create with the right table" do
    ShortUrlsLog.create().should_not be_nil
  end
end
