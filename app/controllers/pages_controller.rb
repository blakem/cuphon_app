class PagesController < ApplicationController
  require 'cuphon_engine'
  
  def sms
    twiml = TwimlSmsRequest.create_from_params(params)
    begin
      run_sms_request(twiml, params)
    rescue Exception => e
      twiml.response = "ERROR: " + e.message + "\n\nBacktrace:" + e.backtrace.inspect
      twiml.save
    end
    @messages = []
  end

  private
  
    def run_sms_request(twiml, params)
      messages = build_messages(params)
      if messages.empty?
        twiml.response = 'Ignored'
      elsif messages[0] == 'Profane'
        twiml.response = 'Profane - No response sent'
      else
        twiml.response = messages.join( '|||' );
        messages.each do |m|
          priority = m =~ /Welcome/ ? 2 : 1
          QueuedMessage.create(:device_id => params[:From], :body => m, :priority => priority)
        end
      end
      twiml.save
    end
    
    def build_messages(params)
       return [] if is_duplicate?(params)
       [ welcome_message(params),
         process_request(params) 
       ].select {|n| n}
    end

    def welcome_message(params)
      Subscriber.find_by_device_id(params[:From]) ? false : OutboundMessages.welcome_message
    end

    def process_request(params)
      (action, brand) = parse_action_and_brand(params[:Body])
      CuphonEngine.perform_action(Subscriber.find_or_create_by_device_id(params[:From]), action, brand)
    end
    
    def parse_action_and_brand(string)
      return [nil, nil] if string.blank?
      string = string.split.join(' ')
      (action, brand) = string.split(/\s+/, 2)
      unless valid_actions.member?(action.upcase)
        brand = string
        action = 'START'
      end
      return action.upcase, brand
    end

    def valid_actions
      %w[START JOIN HELP STOP QUIT UNSUBSCRIBE END RESETSTATUS NO LIST]
    end
    
    def is_duplicate?(params)
      previous = TwimlSmsRequest.find_all_by_From_and_Body(params[:From], params[:Body])
      previous.select { |p| p.created_at > 1.minutes.ago }.length > 1
    end
end
