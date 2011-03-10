require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'test'" do
 
    it "should be successful" do
      get 'test'
      response.should be_success
    end   
  end

  describe "GET 'home'" do
 
    it "should be successful" do
      get 'home'
      response.should be_success
    end   
  end
end
