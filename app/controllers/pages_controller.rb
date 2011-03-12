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
    subscriber = Subscriber.find_or_create_by_device_id(params[:From])    

    response = lookup_response(params[:Body])
    if response.nil?
      brand = Brand.create(:title => params[:Body])
      Subscription.create(:device_id => subscriber.device_id, :brand_id => brand.id, :brand_title => brand.title)
      response = "Welcome to Cuphon! You have been subscribed to #{params[:Body]}"
    end
    return response
  end

  def lookup_response(key)
    key = key.strip.upcase unless key.nil?
    map = message_map
    map[key]
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
