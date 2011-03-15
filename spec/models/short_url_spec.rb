require 'spec_helper'

describe ShortUrl do
  it "should be able to create" do
    ShortUrl.create().should_not be_nil
  end

  describe "default values" do
    it "should set opened to false" do
      short_url = ShortUrl.create
      short_url.opened.should == 'false'

      short_url.reload
      short_url.opened.should == 'false'
    end
  end
end
