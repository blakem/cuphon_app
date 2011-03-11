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

    before(:each) do
      @valid = {
        :From => '12345',
        :Body => 'START',
        :format => 'xml'
      }
    end
 
    describe "success" do
      it "should be successful" do
        lambda do
          post 'sms', @valid
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
      end

      it "should log a TwimlSmsRequest even with other random stuff submitted" do
        lambda do
          post 'sms', @valid.merge(:Garbage => 'Foo')
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
      end
    end

    describe "commands" do

      it "should respond to START" do
        post 'sms', @valid.merge(:Body => 'START')
        response.should have_selector('response>sms', :content => 'Welcome')
      end

      it "should respond commands with spaces and caps" do
        post 'sms', @valid.merge(:Body => '     STarT   ')
        response.should have_selector('response>sms', :content => 'Welcome')
      end

      it "should respond to garbled output with help message" do
        post 'sms', @valid.merge(:Body => 'alskdfjlasdfj')
        response.should have_selector('response>sms', :content => 'Sorry')
      end

      it "should respond to HELP" do
        post 'sms', @valid.merge(:Body => 'HELP')
        response.should have_selector('response>sms', :content => "Cuphon.com enables merchants to send" )        
      end

      it "should respond to STOP" do
        post 'sms', @valid.merge(:Body => 'STOP')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended" )        
      end
    end
  end

  describe "GET 'home'" do
 
    it "should be successful" do
      get 'home'
      response.should be_success
    end   
  end
end
