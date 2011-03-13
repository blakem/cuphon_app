class PagesController < ApplicationController
  require 'profanity_checker'

  def sms
    twiml = TwimlSmsRequest.create_from_params(params)
    @messages = []
    if !Subscriber.find_by_device_id(params[:From])
      @messages << "Welcome to Cuphon! Reply with STOP to stop. Reply HELP for help. Msg & data rates may apply. Max 3 msgs/week per merchant. Visit Cuphon.com to learn more!"
    end
    message = process_request(params)
    @messages << message if message.length > 0 
    twiml.response = @messages.join( '|||' );
    twiml.save
  end

  private

    def process_request(params)
      subscriber = Subscriber.find_or_create_by_device_id(params[:From])
      (action, brand) = parse_action_and_brand(params[:Body])
      perform_action(subscriber, action, brand)
    end
    
    def perform_action(subscriber, action, brand)
      case action
      when 'JOIN'
        perform_action(subscriber, 'START', brand)
      when 'START'
        if ProfanityChecker.has_profane_word?(brand)
          ""
        else
          subscriber.subscribe!(brand)
          "You've been subscribed to #{brand}! Soon you'll get coupons directly from this merchant, spread the word and keep discovering!"
        end
      when 'HELP'
        "Cuphon.com enables merchants to send coupons directly to your phone! Max 3 msgs/week per merchant. Reply STOP to cancel. Msg&data rates may apply."

      when 'END'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'STOP'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'QUIT'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'UNSUBSCRIBE'
        if brand.nil? or brand =~ /^all$/i
          subscriber.brands.each do |brand|
            subscriber.unsubscribe!(brand)
          end
          "Your subscriptions have been suspended. You will no longer receive coupon offers! To activate your subscriptions, reply with START at any time! Thx, Cuphon.com"
        else
          if subscriber.is_subscribed?(brand)
            subscriber.unsubscribe!(brand)
            "Your subscription to #{brand} has been suspended. You will no longer receive coupon offers! To activate your subscription, reply with START #{brand} at any time! Thx, Cuphon.com"
          else
            "You are not currently subscribed to #{brand}."
          end
        end
      when 'RESETSTATUS'
        subscriber.brands.each do |brand|
          subscriber.unsubscribe!(brand)
        end
        subscriber.destroy
        "You are now reset to a new user"
      else
        "Sorry, we didn't understand your message. Reply HELP for help. Reply STOP to cancel messages."
      end
    end

    def parse_action_and_brand(string)
      return [nil, nil] unless string
      string = string.split.join(' ')
      (action, brand) = string.split(/\s+/, 2)
      if !valid_actions.member?(action.upcase)
        brand = string
        action = 'START'
      end
      return [action.upcase, brand]
    end

    def valid_actions
      %w[START JOIN HELP STOP QUIT UNSUBSCRIBE END RESETSTATUS] << "STOP ALL"
    end
end
