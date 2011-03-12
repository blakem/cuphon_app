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

     it "should not crash w/o a body" do
        lambda do
          invalid_args = @valid
          invalid_args.delete(:Body)
          post 'sms', invalid_args
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
      end

      it "should log a TwimlSmsRequest even with other random stuff submitted" do
        lambda do
          post 'sms', @valid.merge(:Garbage => 'Foo')
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
      end

      it "should store the response in the TwimlSmsRequest" do
        from = '9034823947239478'
        post 'sms', @valid.merge(:From => from, :Body => 'STOP ALL')
        response.should be_success
        TwimlSmsRequest.find_by_From(from).response.should =~ /Your subscriptions have been suspended/
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
        post 'sms', @valid.merge(:Body => 'alskdasdfslasdfj')
        response.should have_selector('response>sms', :content => 'have been subscribed') # How do we tell between garbage and real tags?
      end

      it "should respond to HELP" do
        post 'sms', @valid.merge(:Body => 'HELP')
        response.should have_selector('response>sms', :content => "Cuphon.com enables merchants to send")        
      end

      it "should respond to STOP" do
        post 'sms', @valid.merge(:Body => 'STOP')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end
    end

    describe "Matching with brands" do

      describe "when it's their first time" do
    
        it "should create a brand if it doesn't exist" do
          body = 'TastyPickles'
          phone = Factory.next(:phone)
          lambda do
            lambda do
              post 'sms', @valid.merge(:Body => body, :From => phone )
              response.should have_selector('response>sms', :content => "been subscribed to #{body}")
            end.should change(Brand, :count).by(1)
          end.should change(Subscriber, :count).by(1)
          brand = Brand.find_by_title(body)
          brand.title.should == body
          subscriber = Subscriber.where(:device_id => phone)
          subscriber.should_not be_nil
          
          subscription = Subscription.where(:device_id => phone, :brand_id => brand.id).first
          subscription.should_not be_nil
        end
      end
      
      describe "when they already exist" do
        it "should use the existing subscriber" do
          phone = Factory.next(:phone)
          body = 'YummySandwich'
          subscriber = Subscriber.create(:device_id => phone)
          lambda do
            post 'sms', @valid.merge(:Body => body, :From => phone )
            response.should have_selector('response>sms', :content => "been subscribed to #{body}")
          end.should_not change(Subscriber, :count)

          brand = Brand.find_by_title(body)
          subscription = Subscription.where(:device_id => phone, :brand_id => brand.id).first
          subscription.brand.should == brand
          
          subscriber.subscriptions.should include(subscription)
          subscriber.brands.should include(brand)
        end
        
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
