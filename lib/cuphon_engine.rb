module CuphonEngine
  require 'outbound_messages'
  require 'profanity_checker'

  class << self

    def perform_action(subscriber, action, brand)
      case action
      when 'JOIN'
        perform_action(subscriber, 'START', brand)
      when 'START'
        if ProfanityChecker.has_profane_word?(brand)
          ""
        else
          subscriber.subscribe!(brand)
          brand_obj = Brand.find_by_title(brand)
          if !brand_obj.nil? and brand_obj.has_active_instant?
            brand_obj.send_active_message
          else
            OutboundMessages.subscribed_message(brand)
          end
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
  end  
end