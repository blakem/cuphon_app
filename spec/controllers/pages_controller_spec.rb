require 'spec_helper'

describe PagesController do
  render_views
  
  after(:each) do
    BrandsInstant.all.each { |o| o.destroy }
    Brand.all.each { |o| o.destroy }
    Subscriber.all.each { |o| o.destroy }
    QueuedMessage.all.each { |o| o.destroy }
  end
  
  describe "POST 'sms.xml'" do

    before(:each) do
      @valid = {
        :From => '+12223334444',
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

    def tweak_response(response)
      messages = ''
      QueuedMessage.all.map { |m| m.body }.each do |m|
        messages += "<Sms>#{m}</Sms>"
      end
      response.body = "<Response>#{messages}<Response>"
    end

    describe "basic commands" do

      it "should respond to START" do
        post 'sms', @valid.merge(:Body => 'START')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Welcome")        
      end

      it "should respond to HELP" do
        post 'sms', @valid.merge(:Body => 'HELP')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Cuphon.com enables merchants to send")        
      end

      it "should respond to STOP" do
        post 'sms', @valid.merge(:Body => 'STOP')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      it "should respond to JOIN" do
        post 'sms', @valid.merge(:Body => 'JOIN')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Welcome to Cuphon!")        
      end

      it "should respond to QUIT" do
        post 'sms', @valid.merge(:Body => 'QUIT')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      it "should respond to NO" do
        post 'sms', @valid.merge(:Body => 'NO')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end
      
      it "should respond to UNSUBSCRIBE" do
        post 'sms', @valid.merge(:Body => 'UNSUBSCRIBE')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      it "should respond to END" do
        post 'sms', @valid.merge(:Body => 'END')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end
      it "should respond to STOP ALL" do
        post 'sms', @valid.merge(:Body => 'STOP ALL')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Your subscriptions have been suspended")        
      end

      describe "variations on commands" do
        it "should respond commands with spaces and caps" do
          post 'sms', @valid.merge(:Body => '     STarT   ')
          tweak_response(response)
          response.should have_selector('response>sms', :content => 'Welcome')
        end

        it "should respond commands with spaces and caps in help" do
          post 'sms', @valid.merge(:Body => ' HeLp ')
          tweak_response(response)
          response.should have_selector('response>sms', :content => "Cuphon.com enables merchants to send")        
        end

        it "should respond to garbled output with help message" do
          post 'sms', @valid.merge(:Body => 'alskdasdfslasdfj')
          tweak_response(response)
          response.should have_selector('response>sms', :content => "You've been subscribed to") # How do we tell between garbage and real tags?
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
              tweak_response(response)
              response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
              response.should have_selector('response>sms', :content => "been subscribed to #{body}")
            end.should change(Brand, :count).by(1)
          end.should change(Subscriber, :count).by(1)
          brand = Brand.find_by_title(body)
          brand.title.should == body
          subscriber = Subscriber.find_by_device_id(phone)
          subscriber.is_subscribed?(brand).should be_true
        end
      
        it "When creating a brand it should create a brand instant as well" do
          body = 'OriginalTastyPickles'
          phone = Factory.next(:phone)
          lambda do
            post 'sms', @valid.merge(:Body => body, :From => phone )
            tweak_response(response)
            response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
            response.should have_selector('response>sms', :content => "been subscribed to #{body}")
          end.should change(BrandsInstant, :count).by(1)
        end

      end

      describe "when they already exist" do
        it "should use the existing subscriber" do
          phone = Factory.next(:phone)
          body = 'YummySandwich'
          subscriber = Subscriber.create(:device_id => phone)
          lambda do
            post 'sms', @valid.merge(:Body => body, :From => phone )
            tweak_response(response)
            response.should have_selector('response>sms', :content => "been subscribed to #{body}")
            response.should_not have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
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
          tweak_response(response)
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
          tweak_response(response)
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
          tweak_response(response)
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
        tweak_response(response)
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
           tweak_response(response)
           subscriber.reload
           subscriber.is_subscribed?(brand).should be_true
         end
      end
    end

    describe "subscribing to a list you're already subscribed to" do
      it "should send appropriate message" do
        brand = Factory(:brand)
        subscriber = Factory(:subscriber)
        subscriber.subscribe!(brand)
        post 'sms', @valid.merge(:Body => brand.title, :From => subscriber.device_id)
        tweak_response(response)
        response.should have_selector('response>sms', :content => "You are already subscribed to #{brand.title}.")
      end
    end
    
    describe "subscribing with a string that has multiple spaces in" do
       it "should trim out the multiple spaces" do
         msg = '    Jamba    Cat   Dog   Pig    '
         brand_msg = 'Jamba Cat Dog Pig'
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "been subscribed to #{brand_msg}")
         subscriber.reload
         subscriber.is_subscribed?(brand_msg).should be_true
       end

       it "should trim out the multiple spaces with leading start" do
         msg = '   start    Jamba    Cat   Dog   Pig    '
         brand_msg = 'Jamba Cat Dog Pig'
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         tweak_response(response)
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
         tweak_response(response)
         response.should_not have_selector('response>sms')
         subscriber.reload
         subscriber.is_subscribed?(msg).should be_false
         Brand.find_by_title(msg).should be_nil
       end

       it "should ignore 'sentences with MILF in them'" do
         msg = 'sentences with MILF in them'         
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         tweak_response(response)
         response.should_not have_selector('response>sms')         
         subscriber.reload
         subscriber.is_subscribed?(msg).should be_false
         Brand.find_by_title(msg).should be_nil
       end
    end

    describe "RESETSTATUS message will erase a user from the db" do
      it "should remove a user if sent RESETSTATUS message" do
        device_id = Factory.next(:phone)
        brand = Factory(:brand)
        subscriber = Factory(:subscriber, :device_id => device_id)
        subscriber.subscribe!(brand)
        post 'sms', @valid.merge(:Body => "RESETSTATUS", :From => subscriber.device_id)
        tweak_response(response)
        response.should have_selector('response>sms', :content => "You are now reset to a new user")
        Subscription.find_by_device_id_and_brand_id(device_id, brand.id).should be_nil
        Subscriber.find_by_device_id(device_id).should be_nil
      end
    end
    
    describe "instant coupon" do
      it "should send an instant coupon when one is found" do
        # "Cuphon from Starbucks: Come in for our new holiday lattes, buy one get one 50% off!. More: http://cphn.me/sbux1"
        brand = Factory(:brand)
        brand_instant = BrandsInstant.create(:brand_id => brand.id, 
                                             :title => 'An instant coupon for you!',
                                             :description => 'Come in for our new holiday lattes, buy one get one 50% off!')
        phone = Factory.next(:phone)
        post 'sms', @valid.merge(:Body => brand.title, :From => phone)
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
        response.should have_selector('response>sms', :content => "Cuphon from #{brand.title}: #{brand_instant.description} More: ")
        response.body.should =~ /More: http:\/\/cphn.me\/[a-z0-9]{5}/
        response.should_not have_selector('response>sms', :content => "been subscribed to #{brand.title}")        
        response.should_not have_selector('response>sms', :content => "been subscribed to")
        response.body =~ /More: (http:\/\/cphn.me\/[a-z0-9]{5})/
        short_url = ShortUrl.find_by_url($1)
        short_url.should_not be_nil
      end
      
      it "should match on case insensitive" do
         brand = Factory(:brand, :title => 'WikiWooWorkshop')
         brand_instant = BrandsInstant.create(:brand_id => brand.id)
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => '  join wikiWOOworkShop   ', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "Cuphon from WikiWooWorkshop:")
         response.should_not have_selector('response>sms', :content => "been subscribed to #{brand.title}")
         response.should_not have_selector('response>sms', :content => "been subscribed to")
      end

      it "should not match if instant is disabled on the brand" do
         brand = Factory(:brand, :title => 'MyInstantsAreOff', :instant => false)
         brand_instant = BrandsInstant.create(:brand_id => brand.id)
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => 'JOIN MyInstantsAreOff', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "been subscribed to #{brand.title}")
         response.should_not have_selector('response>sms', :content => "Cuphon from MyInstantsAreOff:")
      end

      it "should match on an alias with an instant coupon" do
         brand = Factory(:brand, :title => 'WikiWooWorkshop')
         brand_instant = BrandsInstant.create(:brand_id => brand.id, :title => 'An instant coupon for you!')
         brand_alias = BrandsAlias.create(:brand_id => brand.id, :alias => 'AnotherCoolName')
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => '  join AnotherCoolName   ', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "Cuphon from WikiWooWorkshop:")
         response.should_not have_selector('response>sms', :content => "been subscribed to #{brand.title}")        
         response.should_not have_selector('response>sms', :content => "been subscribed to")
      end

      it "should match on an alias without an instant coupon" do
         brand = Factory(:brand, :title => 'WikiWooWorkshop2')
         brand_alias = BrandsAlias.create(:brand_id => brand.id, :alias => 'AnotherCoolName2')
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => '  join AnotherCOOLName2   ', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "been subscribed to #{brand.title}")        
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
