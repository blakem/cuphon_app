module CuphonEngine
  require 'outbound_messages'
  require 'profanity_checker'

  class << self

    def perform_action(subscriber, action, brand, welcome)
      case action
      when 'JOIN', 'START'
        perform_start_action(subscriber, brand, welcome)
      when 'END', 'STOP', 'QUIT', 'UNSUBSCRIBE', 'NO'
        perform_stop_action(subscriber, brand, welcome)
      when 'HELP'
        OutboundMessages.help_message
      when 'LIST'
        perform_list_action(subscriber, brand, welcome)
      when 'RESETSTATUS'
        perform_reset_action(subscriber, brand, welcome)
      else
        OutboundMessages.sorry_message
      end
    end

    private
      def perform_start_action(subscriber, brand, welcome)
        if brand.nil? or brand == ''
          subscriber.active = 'true'
          subscriber.save
          return welcome ? false : OutboundMessages.restart_message
        end
        return 'Profane' if ProfanityChecker.has_profane_word?(brand)
        return OutboundMessages.brand_too_long_message if brand.length >= 25
        if brand_obj = Brand.find_by_fuzzy_match(brand)
          return OutboundMessages.already_subscribed_message(brand_obj.title) if subscriber.is_subscribed?(brand_obj)
          subscriber.subscribe!(brand_obj)
          if brand_obj.has_active_instant?
            loginstant = LogInstantCuphon.where(:device_id => subscriber.device_id, :brand_id => brand_obj.id)
            return OutboundMessages.subscribed_message(brand_obj.title) if loginstant.any?
            LogInstantCuphon.create(:device_id => subscriber.device_id, :brand_id => brand_obj.id)
            brand_obj.send_active_message
          else
            OutboundMessages.subscribed_message(brand_obj.title)
          end
        else
          subscriber.subscribe!(brand)
          brand_obj = Brand.find_by_fuzzy_match(brand)
          OutboundMessages.subscribed_message(brand_obj ? brand_obj.title : brand)
        end
      end
    
      def perform_stop_action(subscriber, brand, welcome)
        if brand.nil? or brand =~ /^all$/i
          subscriber.unsubscribe_all!
          OutboundMessages.unsubscribe_all_message
        else
          if subscriber.is_subscribed?(brand)
            brand_obj = Brand.find_by_fuzzy_match(brand)
            subscriber.unsubscribe!(brand_obj)
            OutboundMessages.unsubscribe_message(brand_obj.title)
          else
            OutboundMessages.not_currently_subscribed_message(brand)
          end
        end
      end
      
      def perform_reset_action(subscriber, brand, welcome)
        LogInstantCuphon.find_all_by_device_id(subscriber.device_id).each { |l| l.destroy }
        subscriber.unsubscribe!(*subscriber.brands)
        subscriber.destroy
        OutboundMessages.resetstatus_message
      end
      
      def perform_list_action(subscriber, brand, welcome)
        return OutboundMessages.list_none_message unless subscriber.active?
        brands = subscriber.brands
        return OutboundMessages.list_none_message if brands.empty?
        return OutboundMessages.list_cuphons_message(brands)
      end
  end  
end