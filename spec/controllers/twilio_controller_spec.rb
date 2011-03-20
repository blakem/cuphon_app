# coding: UTF-8

require 'spec_helper'

describe TwilioController do
  render_views
  
  after(:each) do
    BrandInstant.all.each { |o| o.destroy }
    Brand.all.each { |o| o.destroy }
    Subscriber.all.each { |o| o.destroy }
    QueuedMessage.all.each { |o| o.destroy }
    TwimlSmsRequest.all.each { |o| o.destroy }
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
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end
    
      it "should not crash with an empty body" do
        lambda do
          invalid_args = @valid
          invalid_args[:Body] = ""
          post 'sms', invalid_args
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end
      
      it "should not crash with a missing body" do
        lambda do
          invalid_args = @valid
          invalid_args.delete(:Body)
          post 'sms', invalid_args
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end
      
      it "should not crash with body of only whitespace" do
        lambda do
          invalid_args = @valid
          invalid_args[:Body] = "            "
          post 'sms', invalid_args
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end

      it "should handle utf8 characters" do
        lambda do
          post 'sms', @valid.merge(:Body => "ėččę91")
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
        TwimlSmsRequest.last.response.should =~ /You've been subscribed to ėččę91!/
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end

      it "should log a TwimlSmsRequest even with other random stuff submitted" do
        lambda do
          post 'sms', @valid.merge(:Garbage => 'Foo')
          response.should be_success
        end.should change(TwimlSmsRequest, :count).by(1) 
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end

      it "should store the response in the TwimlSmsRequest" do
        from = '9034823947239478'
        post 'sms', @valid.merge(:From => from, :Body => 'STOP ALL')
        response.should be_success
        TwimlSmsRequest.find_by_From(from).response.should =~ /Your subscriptions have been suspended/
        TwimlSmsRequest.last.response.should_not =~ /error/i
      end
    end

    def tweak_response(response, delete_queued = true)
      messages = ''
      QueuedMessage.all.map { |m| m.body }.each do |m|
        messages += "<Sms>#{m}</Sms>"
      end
      QueuedMessage.all.each { |q| q.destroy } if delete_queued
      response.body = "<Response>#{messages}<Response>"
    end

    describe "basic commands" do

      it "should not actually send any replys" do
        post 'sms', @valid.merge(:Body => 'START')
        response.should_not have_selector('response>sms')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Welcome")        
      end
      
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
      it "should respond to LIST" do
        post 'sms', @valid.merge(:Body => 'LIST')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "You are not subscribed to any brands.")        
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
        
        it "should respond commands with a welcome message for a new user with a simple start message" do
          post 'sms', @valid.merge(:Body => 'START', :From => Factory.next(:phone) + 'foobarbaz')
          tweak_response(response, false)
          response.should have_selector('response>sms', :content => 'Welcome to Cuphon! Reply with STOP to stop. Reply HELP for help.')
          response.should_not have_selector('response>sms', :content => 'been subscribed to')
          response.should_not have_selector('response>sms', :content => 'Your subscriptions have been restarte')
          QueuedMessage.all.count.should == 1
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
          brand.active?.should be_true
          brand.in_app?.should be_false
          subscriber = Subscriber.find_by_device_id(phone)
          subscriber.is_subscribed?(brand).should be_true
        end
        
        it "should create a canonical alias without spaces or punctuation and be in all lowercase" do
          body = ' I  Like        JellyBeans! '
          brand_created = 'I Like JellyBeans!'
          canonical = 'ilikejellybeans'
          phone = Factory.next(:phone)
          post 'sms', @valid.merge(:Body => body, :From => phone )
          tweak_response(response)
          response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
          response.should have_selector('response>sms', :content => "been subscribed to #{brand_created}")
          brand_alias = BrandAlias.find_by_alias(canonical)
          brand_alias.alias.should == canonical
          brand = Brand.find_by_fuzzy_match(canonical)
          brand.title.should == brand_created
          brand_alias.brand.should == brand
        end

        it "should match a canonical alias without spaces or punctuation and be in all lowercase" do
          body = ' I  LikE-JellyB  ea!!!ns '
          brand_title = 'I Like JellyBeans!!'
          canonical = 'ilikejellybeans'
          subscriber = Factory(:subscriber)
          brand = Factory(:brand, :title => brand_title)
          BrandAlias.create(:brand_id => brand.id, :alias => canonical)
          post 'sms', @valid.merge(:Body => body, :From => subscriber.device_id )
          tweak_response(response)
          response.should have_selector('response>sms', :content => "been subscribed to #{brand_title}")
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
          end.should change(BrandInstant, :count).by(1)
        end

        it "When creating a brand it should Upercase each word" do
          body = ' fancy  yummy good     muffin    '
          brand_title = 'Fancy Yummy Good Muffin'
          subscriber = Factory(:subscriber)
          post 'sms', @valid.merge(:Body => body, :From => subscriber.device_id )
          tweak_response(response)
          response.should have_selector('response>sms', :content => "been subscribed to #{brand_title}")
          brand = Brand.find_by_title(brand_title)
          brand.title.should == brand_title
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
          brand.title += cmd
          brand.save
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

          post 'sms', @valid.merge(:Body => "START", :From => subscriber.device_id)
          tweak_response(response)
          response.should have_selector('response>sms', :content => "Your subscriptions have been restarted")
          subscriber.reload
          subscriber.is_subscribed?(brand1).should be_true      
          subscriber.is_subscribed?(brand2).should be_true      
          subscriber.is_subscribed?(brand3).should be_true           
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

    describe "Duplicate messages" do
      it "should not create multiple responses" do
        brand = Factory(:brand, :title => 'SomethingNewAndDifferent')
        subscriber = Factory(:subscriber)
        subscriber.subscribe!(brand)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        QueuedMessage.all.length.should == 1
        twimls = TwimlSmsRequest.all
        twimls.count.should == 3
        twimls.select { |t| t.response =~ /already/ }.count.should == 1
        twimls.select { |t| t.response =~ /Ignored/ }.count.should == 2
      end

      it "should ignore messages from longer than 1 minute ago" do
        brand = Factory(:brand, :title => 'SomethingNewerAndDifferent')
        subscriber = Factory(:subscriber)
        subscriber.subscribe!(brand)
        twiml = TwimlSmsRequest.create(:From => subscriber.device_id, :Body => "START #{brand.title}")
        twiml.updated_at = twiml.created_at = 2.minutes.ago
        twiml.save
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        QueuedMessage.all.length.should == 1
      end
      
      it "should only treat case sensitve matches as duplicates" do
        brand = Factory(:brand, :title => 'SomethingNewAndDifferent')
        subscriber = Factory(:subscriber)
        subscriber.subscribe!(brand)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "START #{brand.title}", :From => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "STaRT #{brand.title}", :From => subscriber.device_id)
        QueuedMessage.all.length.should == 2
        twimls = TwimlSmsRequest.all
        twimls.count.should == 3
        twimls.select { |t| t.response =~ /already/ }.count.should == 2
        twimls.select { |t| t.response =~ /Ignored/ }.count.should == 1
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
         twiml = TwimlSmsRequest.find_by_From(subscriber.device_id)
         twiml.response.should == 'Profane - No response sent'
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

       it "should ignore strings that match a certain pattern" do
         msg = 'thisIs a sentence withFuckIn the middle'
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         tweak_response(response)
         response.should_not have_selector('response>sms')         
         subscriber.reload
         subscriber.is_subscribed?(msg).should be_false
         Brand.find_by_title(msg).should be_nil
       end

       it "should ignore words in the bad_words table" do
         msg = 'Dog Cat Pig'
         subscriber = Factory(:subscriber)
         bad_word = BadWord.create(:word => 'cat')
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         tweak_response(response, false)
         response.should_not have_selector('response>sms', :content => "been subscribed to #{msg}")
         QueuedMessage.all.count.should == 0
       end

       it "should ignore phrases in the bad_words table" do
         msg = ' Dog  Cat  Pig '
         subscriber = Factory(:subscriber)
         bad_word = BadWord.create(:word => 'dog cat pig')
         post 'sms', @valid.merge(:Body => msg, :From => subscriber.device_id)
         tweak_response(response, false)
         response.should_not have_selector('response>sms', :content => "been subscribed to Dog Cat Pig")
         QueuedMessage.all.count.should == 0
       end
    end

    describe "RESETSTATUS message will erase a user from the db" do
      it "should remove a user if sent RESETSTATUS message" do
        device_id = Factory.next(:phone)
        brand = Factory(:brand)
        subscriber = Factory(:subscriber, :device_id => device_id)
        subscriber.subscribe!(brand)
        LogInstantCuphon.create(:brand_id => brand.id, :device_id => subscriber.device_id)
        post 'sms', @valid.merge(:Body => "RESETSTATUS", :From => subscriber.device_id)
        tweak_response(response)
        response.should have_selector('response>sms', :content => "You are now reset to a new user")
        Subscription.find_by_device_id_and_brand_id(device_id, brand.id).should be_nil
        Subscriber.find_by_device_id(device_id).should be_nil
        LogInstantCuphon.where(:brand_id => brand.id, :device_id => subscriber.device_id).count.should == 0
      end
    end

    describe "LIST command" do
      it "should list the groups you are subscribed to" do
        brand1 = Factory(:brand)
        brand2 = Factory(:brand)
        brand3 = Factory(:brand)
        subscriber = Factory(:subscriber)
        subscriber.subscribe!(brand1, brand2, brand3)
        post 'sms', @valid.merge(:From => subscriber.device_id, :Body => 'LIST')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "You are subscribed to:")
        response.should have_selector('response>sms', :content => brand1.title)
        response.should have_selector('response>sms', :content => brand2.title)
        response.should have_selector('response>sms', :content => brand3.title)

        post 'sms', @valid.merge(:From => subscriber.device_id, :Body => 'STOP')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "suspended")

        post 'sms', @valid.merge(:From => subscriber.device_id, :Body => 'LiSt')
        tweak_response(response)
        response.should have_selector('response>sms', :content => "You are not subscribed to any brands.")
        
      end      
    end
    
    describe "instant coupon" do
      it "should send an instant coupon when one is found" do
        # "Cuphon from Starbucks: Come in for our new holiday lattes, buy one get one 50% off!. More: http://cphn.me/sbux1"
        brand = Factory(:brand)
        brand_instant = BrandInstant.create(:brand_id => brand.id, 
                                             :description => 'Come in for our new holiday lattes, buy one get one 50% off!')
        phone = Factory.next(:phone)
        post 'sms', @valid.merge(:Body => brand.title, :From => phone)
        tweak_response(response, false)
        response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
        response.should have_selector('response>sms', :content => "Cuphon from #{brand.title}: #{brand_instant.description} More: ")
        response.body.should =~ /More: cuphon.com\/[a-z0-9]{5}/
        response.should_not have_selector('response>sms', :content => "been subscribed to #{brand.title}")        
        response.should_not have_selector('response>sms', :content => "been subscribed to")
        response.body =~ /More: cuphon.com\/([a-z0-9]{5})/

        short_url = ShortUrl.find_by_url($1)
        short_url.should_not be_nil
        
        QueuedMessage.where('body LIKE ? ', '%Welcome%').first.priority.should == 2
        QueuedMessage.where('body LIKE ? ', '%Cuphon from%').first.priority.should == 1
      end
      
      it "should populate ShortUrl correctly" do
        brand = Factory(:brand)
        brand_instant = BrandInstant.create(:brand_id => brand.id, 
                                             :description => 'Come in for our new holiday lattes, buy one get one 50% off!',
                                             :extended => 'lots more good information',
                                             :image_url => 'http://blakem.com'
                                             )
        phone = Factory.next(:phone)
        post 'sms', @valid.merge(:Body => brand.title, :From => phone)
        tweak_response(response)
        response.should have_selector('response>sms', :content => "Cuphon from #{brand.title}: #{brand_instant.description} More: ")
        response.body =~ /More: cuphon.com\/([a-z0-9]{5})/

        short_url = ShortUrl.find_by_url($1)
        short_url.brand_title.should == brand.title
        short_url.description.should == brand_instant.description
        short_url.extended.should == brand_instant.extended
        short_url.image_url.should == brand_instant.image_url
        short_url.opened.should == 'false'
      end

      it "should match on case insensitive" do
         brand = Factory(:brand, :title => 'WikiWooWorkshop')
         brand_instant = BrandInstant.create(:brand_id => brand.id)
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => '  join wikiWOOworkShop   ', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "Cuphon from WikiWooWorkshop:")
         response.should_not have_selector('response>sms', :content => "been subscribed to #{brand.title}")
         response.should_not have_selector('response>sms', :content => "been subscribed to")
      end

      it "should not send an instant twice if you resubscribe" do
         brand = Factory(:brand)
         brand_instant = BrandInstant.create(:brand_id => brand.id)
         brand.reload
         brand.has_active_instant?.should be_true
         subscriber = Factory(:subscriber)
         post 'sms', @valid.merge(:Body => brand.title, :From => subscriber.device_id)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Cuphon from #{brand.title}")
         LogInstantCuphon.find(:all, :conditions => { :device_id => subscriber.device_id, :brand_id => brand.id }).count.should == 1
         
         post 'sms', @valid.merge(:Body => "stop #{brand.title}", :From => subscriber.device_id)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Your subscription to #{brand.title} has been suspended.")        
         
         post 'sms', @valid.merge(:Body => "start #{brand.title}", :From => subscriber.device_id)
         tweak_response(response)
         response.should_not have_selector('response>sms', :content => "Cuphon from #{brand.title}")
         response.should have_selector('response>sms', :content => "been subscribed to #{brand.title}")
         LogInstantCuphon.find(:all, :conditions => { :device_id => subscriber.device_id, :brand_id => brand.id }).count.should == 1
      end

      it "should not match if instant is disabled on the brand" do
         brand = Factory(:brand, :title => 'MyInstantsAreOff', :instant => false)
         brand_instant = BrandInstant.create(:brand_id => brand.id)
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => 'JOIN MyInstantsAreOff', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "been subscribed to #{brand.title}")
         response.should_not have_selector('response>sms', :content => "Cuphon from MyInstantsAreOff:")
      end

      it "should match on an alias with an instant coupon" do
         brand = Factory(:brand, :title => 'WikiWooWorkshop')
         brand_instant = BrandInstant.create(:brand_id => brand.id)
         brand_alias = BrandAlias.create(:brand_id => brand.id, :alias => 'AnotherCoolName')
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
         brand_alias = BrandAlias.create(:brand_id => brand.id, :alias => 'AnotherCoolName2')
         phone = Factory.next(:phone)
         post 'sms', @valid.merge(:Body => '  join AnotherCOOLName2   ', :From => phone)
         tweak_response(response)
         response.should have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "been subscribed to #{brand.title}")        
      end

      it "should respond with brand.title when already subscribed and on unsubscribe" do
         brand = Factory(:brand, :title => 'WikiWooWorkshop3')
         brand_alias = BrandAlias.create(:brand_id => brand.id, :alias => 'wikiwooworkshop3')
         subscriber = Factory(:subscriber)
         subscriber.subscribe!(brand)
         post 'sms', @valid.merge(:Body => brand_alias.alias, :From => subscriber.device_id)
         tweak_response(response)
         response.should_not have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "You are already subscribed to #{brand.title}")        

         post 'sms', @valid.merge(:Body => "NO #{brand_alias.alias}", :From => subscriber.device_id)
         tweak_response(response)
         response.should_not have_selector('response>sms', :content => "Welcome to Cuphon! Reply with STOP to stop.")
         response.should have_selector('response>sms', :content => "Your subscription to #{brand.title} has been suspended.")        
      end
    end
  end  
end
