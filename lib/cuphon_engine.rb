module CuphonEngine
  require 'outbound_messages'
  require 'profanity_checker'

  class << self

    def perform_action(subscriber, action, brand)
      case action
      when 'JOIN'
        perform_start_action(subscriber, brand)
      when 'START'
        perform_start_action(subscriber, brand)
      when 'END'
        perform_stop_action(subscriber, brand)
      when 'STOP'
        perform_stop_action(subscriber, brand)
      when 'QUIT'
        perform_stop_action(subscriber, brand)
      when 'UNSUBSCRIBE'
        perform_stop_action(subscriber, brand)
      when 'HELP'
        OutboundMessages.help_message
      when 'RESETSTATUS'
        perform_reset_action(subscriber, brand)
      else
        OutboundMessages.sorry_message
      end
    end

    private
      def perform_start_action(subscriber, brand)
        if ProfanityChecker.has_profane_word?(brand)
          ""
        else
          brand_obj = Brand.find_by_fuzzy_match(brand)
          if !brand_obj.nil?
            subscriber.subscribe!(brand_obj)
            if brand_obj.has_active_instant?
              brand_obj.send_active_message
            else
              OutboundMessages.subscribed_message(brand_obj.title)
            end
          else
            subscriber.subscribe!(brand)
            OutboundMessages.subscribed_message(brand)
          end
        end
      end
    
      def perform_stop_action(subscriber, brand)
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
      end
      
      def perform_reset_action(subscriber, brand)
        subscriber.unsubscribe_all!
        subscriber.destroy
        OutboundMessages.resetstatus_message
      end
  end  
end