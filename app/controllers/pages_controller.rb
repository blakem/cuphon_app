class PagesController < ApplicationController
  def voice
  end

  def sms
    twiml = TwimlSmsRequest.create_from_params(params)
    @message = process_request(params)
    twiml.response = @message;
    twiml.save
  end

  private

    def process_request(params)
      subscriber = Subscriber.find_or_create_by_device_id(params[:From])
      (action, brand) = parse_action_and_brand(params[:Body])
      perform_action(subscriber, action, brand)
    end
    
    def perform_action(subscriber, action, brand)
      start_msg = "Welcome to Cuphon! Reply with STOP to stop. Reply HELP for help. Msg & data rates may apply. Max 3 msgs/week per merchant. Visit Cuphon.com to learn more!"
      stop_msg  = "Your subscriptions have been suspended. You will no longer receive coupon offers! To activate your subscriptions, reply with START at any time! Thx, Cuphon.com"

      case action
      when 'START'
        subscriber.subscribe!(brand)
        "Welcome to Cuphon! You have been subscribed to #{brand}"
      when 'JOIN'
        start_msg
      when 'HELP'
        "Cuphon.com enables merchants to send coupons directly to your phone! Max 3 msgs/week per merchant. Reply STOP to cancel. Msg&data rates may apply."
      when 'STOP'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'STOP ALL'
        stop_msg
      when 'QUIT'
        stop_msg
      when 'UNSUBSCRIBE' 
        subscriber.unsubscribe!(brand)
        stop_msg
      when 'END'
        stop_msg
      else
        "Sorry, we didn't understand your message. Reply HELP for help. Reply STOP to cancel messages."
      end
    end

    def parse_action_and_brand(string)
      return [nil, nil] unless string
      if string =~ /^\s*stop\s*all\s*$/i
        return ['STOP ALL', nil]
      end
    
      (action, brand) = string.strip.split(/\s/, 2)
      if !valid_actions.member?(action.upcase)
        brand = action
        action = 'START'
      end
      return [action.upcase, brand]
    end

    def valid_actions
      %w[START JOIN HELP STOP QUIT UNSUBSCRIBE END] << "STOP ALL"
    end
end
