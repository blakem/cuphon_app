class PagesController < ApplicationController
  def voice
  end

  def sms
    twiml = TwimlSmsRequest.create_from_params(params)
    @message = process_request(params)
    twiml.response = @message;
    twiml.save
  end
  
  def process_request(params)
    key = params[:Body]
    key = key.strip.upcase unless key.nil?
    map = message_map
    map[key] || map[""]
  end

  def message_map    
    sorry_msg = "Sorry, we didn't understand your message. Reply HELP for help. Reply STOP to cancel messages."
    start_msg = "Welcome to Cuphon! Reply with STOP to stop. Reply HELP for help. Msg & data rates may apply. Max 3 msgs/week per merchant. Visit Cuphon.com to learn more!"
    help_msg  = "Cuphon.com enables merchants to send coupons directly to your phone! Max 3 msgs/week per merchant. Reply STOP to cancel. Msg&data rates may apply."
    stop_msg  = "Your subscriptions have been suspended. You will no longer receive coupon offers! To activate your subscriptions, reply with START at any time! Thx, Cuphon.com"
    {
      ""            => sorry_msg,
    	"START"       => start_msg,
    	"JOIN"        => start_msg,
    	"HELP"        => help_msg,
    	"STOP"        => stop_msg,
    	"STOP ALL"    => stop_msg,
    	"QUIT"        => stop_msg,
    	"UNSUBSCRIBE" => stop_msg,
    	"END"         => stop_msg,
    }
  end
end
