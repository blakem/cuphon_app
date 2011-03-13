class PagesController < ApplicationController
  require 'cuphon_engine'
  
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
      CuphonEngine.perform_action(subscriber, action, brand)
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
