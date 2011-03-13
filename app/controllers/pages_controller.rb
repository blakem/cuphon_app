class PagesController < ApplicationController
  require 'profanity_checker'
  require 'outbound_messages'

  def sms
    twiml = TwimlSmsRequest.create_from_params(params)
    @messages = []
    if !Subscriber.find_by_device_id(params[:From])
      @messages << OutboundMessages.welcome_message
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
          OutboundMessages.subscribed_message(brand)
        end

      when 'END'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'STOP'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'QUIT'
        perform_action(subscriber, 'UNSUBSCRIBE', brand)
      when 'UNSUBSCRIBE'
        if brand.nil? or brand =~ /^all$/i
          subscriber.unsubscribe_all!
          OutboundMessages.unsubscribe_all_message
        else
          if subscriber.is_subscribed?(brand)
            subscriber.unsubscribe!(brand)
            OutboundMessages.unsubscribe_message(brand)
          else
            OutboundMessages.not_currently_subscribed_message(brand)
          end
        end
        
      when 'HELP'
        OutboundMessages.help_message
      when 'RESETSTATUS'
        subscriber.unsubscribe_all!
        subscriber.destroy
        OutboundMessages.resetstatus_message
      else
        OutboundMessages.sorry_message
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
      %w[START JOIN HELP STOP QUIT UNSUBSCRIBE END RESETSTATUS]
    end
end
