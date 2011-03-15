require 'spec_helper'
require 'short_url_generator'

describe ShortUrlGenerator do
  it "should be 5 character's long" do
    base1 = ShortUrlGenerator.random_base
    base1.length.should == 5
    base1.should =~ /^[a-z0-9]+$/
    
    base2 = ShortUrlGenerator.random_base
    base2.length.should == 5
    base2.should =~ /^[a-z0-9]+$/

    base3 = ShortUrlGenerator.random_base
    base3.length.should == 5
    base3.should =~ /^[a-z0-9]+$/
    
    base1.should_not == base2
    base2.should_not == base3
  end
  
  it "should have a short url" do
    url = ShortUrlGenerator.short_url
    url.should =~ /^http:\/\/cphn.me\/[a-z0-9]{5}$/
  end
  
  it "should ensure that it doesn't already exist" do
    module ShortUrlGenerator
      @@words = ['FOOBAR', 'BAZQUX']
      def self.random_base
        return @@words.shift
      end
    end
    ShortUrl.create(:url => 'FOOBAR')
    url = ShortUrlGenerator.short_url
    url.should == 'http://cphn.me/BAZQUX'
  end
  
end
