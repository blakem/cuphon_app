require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'voice'" do
 
    it "should be successful" do
      get 'voice'
      response.should be_success
    end   
  end

  describe "POST 'sms.xml'" do
 
    it "should be successful" do
      post 'sms', :From => '21334', :format => 'xml'
      response.should be_success
      puts response.body
    end   
  end

  describe "GET 'home'" do
 
    it "should be successful" do
      get 'home'
      response.should be_success
    end   
  end
end
