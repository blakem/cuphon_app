require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'voice'" do
 
    it "should be successful" do
      get 'voice'
      response.should be_success
    end   
  end

  describe "GET 'sms'" do
 
    it "should be successful" do
      get 'sms'
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
