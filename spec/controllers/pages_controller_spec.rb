require 'spec_helper'

describe PagesController do
  render_views
  
  describe "POST 'sms.xml'" do

    before(:each) do
      @valid = {
        :From => Factory.next(:phone),
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

    describe "basic commands" do

      it "should respond to START" do
        post 'sms', @valid.merge(:Body => 'START')
        response.should have_selector('response>sms', :content => 'Welcome')
      end

      it "should respond to HELP" do
        post 'sms', @valid.merge(:Body => 'HELP')
        response.should have_selector('response>sms', :content => "Cuphon.com enables merchants to send")        
      end

      it "should respond to STOP" do
        post 'sms', @valid.merge(:Body => 'STOP')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      it "should respond to JOIN" do
        post 'sms', @valid.merge(:Body => 'JOIN')
        response.should have_selector('response>sms', :content => "Welcome to Cuphon!")        
      end

      it "should respond to QUIT" do
        post 'sms', @valid.merge(:Body => 'QUIT')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      it "should respond to UNSUBSCRIBE" do
        post 'sms', @valid.merge(:Body => 'UNSUBSCRIBE')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      it "should respond to END" do
        post 'sms', @valid.merge(:Body => 'END')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end
      it "should respond to STOP ALL" do
        post 'sms', @valid.merge(:Body => 'STOP ALL')
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      describe "variations on commands" do
        it "should respond commands with spaces and caps" do
          post 'sms', @valid.merge(:Body => '     STarT   ')
          response.should have_selector('response>sms', :content => 'Welcome')
        end

        it "should respond commands with spaces and caps in help" do
          post 'sms', @valid.merge(:Body => ' HeLp ')
          response.should have_selector('response>sms', :content => "Cuphon.com enables merchants to send")        
        end

        it "should respond to garbled output with help message" do
          post 'sms', @valid.merge(:Body => 'alskdasdfslasdfj')
          response.should have_selector('response>sms', :content => 'have been subscribed') # How do we tell between garbage and real tags?
        end
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
              response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
              response.should have_selector('response>sms', :content => "been subscribed to #{body}")
            end.should change(Brand, :count).by(1)
          end.should change(Subscriber, :count).by(1)
          brand = Brand.find_by_title(body)
          brand.title.should == body
          subscriber = Subscriber.find_by_device_id(phone)
          subscriber.is_subscribed?(brand).should be_true
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
          subscriber.is_subscribed?(brand).should be_true
        end
        
      end
    end

   describe "unsubscribing from a single list" do
      %w[STOP QUIT UNSUBSCRIBE END].each do |cmd|
        it "should unsubscribe on '#{cmd} BRAND'" do
          brand = Factory(:brand)
          subscriber = Factory(:subscriber)
          subscriber.subscribe!(brand)
          post 'sms', @valid.merge(:Body => "#{cmd} #{brand.title}", :From => subscriber.device_id)
          response.should have_selector('response>sms', :content => "Your subscription to #{brand.title} has been suspended")
          subscriber.reload
          subscriber.is_subscribed?(brand).should be_false      
        end
      end
    end

    describe "unsubscribing from a all list using CMD" do
      %w[STOP QUIT UNSUBSCRIBE END].each do |cmd|
        it "should unsubscribe to everything on '#{cmd}'" do
          brand1 = Factory(:brand)
          brand2 = Factory(:brand)
          brand3 = Factory(:brand)
          subscriber = Factory(:subscriber)
          subscriber.subscribe!(brand1)
          subscriber.subscribe!(brand2)
          subscriber.subscribe!(brand3)
          post 'sms', @valid.merge(:Body => "#{cmd}", :From => subscriber.device_id)
          response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")
          subscriber.reload
          subscriber.is_subscribed?(brand1).should be_false      
          subscriber.is_subscribed?(brand2).should be_false      
          subscriber.is_subscribed?(brand3).should be_false      
        end
      end
    end

    describe "unsubscribing from a all list using CMD ALL" do
      %w[STOP QUIT UNSUBSCRIBE END].each do |cmd|
        it "should unsubscribe to everything on '#{cmd} ALL'" do
          brand1 = Factory(:brand)
          brand2 = Factory(:brand)
          brand3 = Factory(:brand)
          subscriber = Factory(:subscriber)
          subscriber.subscribe!(brand1)
          subscriber.subscribe!(brand2)
          subscriber.subscribe!(brand3)
          post 'sms', @valid.merge(:Body => "#{cmd} All", :From => subscriber.device_id)
          response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")
          subscriber.reload
          subscriber.is_subscribed?(brand1).should be_false      
          subscriber.is_subscribed?(brand2).should be_false      
          subscriber.is_subscribed?(brand3).should be_false      
        end
      end
    end
    
    describe "unsubscribing from a brand that you're not already subscribed to" do
      it "should send message on 'STOP unknownbrand'" do
        brand = Factory(:brand)
        subscriber = Factory(:subscriber)
        subscriber.is_subscribed?(brand).should be_false      
        post 'sms', @valid.merge(:Body => "STOP #{brand.title}", :From => subscriber.device_id)
        response.should have_selector('response>sms', :content => "You are not currently subscribed to #{brand.title}.")
        subscriber.reload
        subscriber.is_subscribed?(brand).should be_false      
      end
    end

    describe "subscribing to a single list" do
      ['START', 'JOIN', ''].each do |cmd|
         it "should subscribe on '#{cmd} BRAND'" do
           brand = Factory(:brand)
           subscriber = Factory(:subscriber)
           post 'sms', @valid.merge(:Body => "#{cmd} #{brand.title}", :From => subscriber.device_id)
           subscriber.reload
           subscriber.is_subscribed?(brand).should be_true
         end
      end
    end

    describe "subscribing with a string that has multiple spaces in" do
       it "should trim out the multiple spaces" do
         msg = '    Jamba    Cat   Dog   Pig    '
         brand_msg = 'Jamba Cat Dog Pig'
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         response.should have_selector('response>sms', :content => "been subscribed to #{brand_msg}")
         subscriber.reload
         subscriber.is_subscribed?(brand_msg).should be_true
       end

       it "should trim out the multiple spaces with leading start" do
         msg = '   start    Jamba    Cat   Dog   Pig    '
         brand_msg = 'Jamba Cat Dog Pig'
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         response.should have_selector('response>sms', :content => "been subscribed to #{brand_msg}")
         subscriber.reload
         subscriber.is_subscribed?(brand_msg).should be_true
       end
    end

    describe "Ignore profanity" do
       it "should ignore 'MILF'" do
         msg = 'MILF'
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         response.should_not have_selector('response>sms')
         subscriber.reload
         subscriber.is_subscribed?(msg).should be_false
         Brand.find_by_title(msg).should be_nil
       end

       it "should ignore 'sentences with MILF in them'" do
         msg = 'sentences with MILF in them'         
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         response.should_not have_selector('response>sms')         
         subscriber.reload
         subscriber.is_subscribed?(msg).should be_false
         Brand.find_by_title(msg).should be_nil
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
