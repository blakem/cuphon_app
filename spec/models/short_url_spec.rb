require 'spec_helper'

describe ShortUrl do
  it "should be able to create" do
    ShortUrl.create().should_not be_nil
  end
end
