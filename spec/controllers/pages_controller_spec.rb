require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'home'" do
 
    it "should be successful" do
      get 'home'
      response.should be_success
      puts response.body.inspect
    end   
  end
end
