module OutboundMessages
  class << self
    def welcome_message
      "Welcome to Cuphon! Reply with STOP to stop. Reply HELP for help. Msg & data rates may apply. Max 3 msgs/week per merchant. Visit Cuphon.com to learn more!"
    end
    def subscribed_message(brand)
      "You've been subscribed to #{brand}! Soon you'll get coupons directly from this merchant, spread the word and keep discovering!"
    end
    def help_message
      "Cuphon.com enables merchants to send coupons directly to your phone! Max 3 msgs/week per merchant. Reply STOP to cancel. Msg&data rates may apply."
    end
    def unsubscribe_all_message
      "Your subscriptions have been suspended. You will no longer receive coupon offers! To activate your subscriptions, reply with START at any time! Thx, Cuphon.com"
    end
    def unsubscribe_message(brand)
      "Your subscription to #{brand} has been suspended. To activate your subscription, reply with START #{brand} at any time! Thx, Cuphon.com"
    end
    def not_currently_subscribed_message(brand)
      "You are not currently subscribed to #{brand}."
    end
    def resetstatus_message
      "You are now reset to a new user"
    end
    def sorry_message
      "Sorry, we didn't understand your message. Reply HELP for help. Reply STOP to cancel messages."
    end
    def instant_cuphon_message(brand, description, url)
      "Cuphon from #{brand}: #{description} More: #{url}"
    end
    def already_subscribed_message(brand)
      "You are already subscribed to #{brand}."
    end
    def list_none_message
      "Your are not subscribed to any merchants."
    end
    def list_cuphons_message(brands)
      "Your are subscribed to: #{brands.map { |b| b.title }.join(', ')}"
    end
  end 
end