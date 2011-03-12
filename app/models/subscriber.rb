class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :foreign_key => 'device_id', :primary_key => 'device_id'

  def brands
    # has_many :brands, :through => :subscriptions
    self.subscriptions.map{ |s| s.brand }
  end

  def subscribe!(brand)
    return unless brand
    
    if !brand.respond_to?(:id)
      brand_str = brand
      brand = Brand.find_or_create_by_title(brand)
    end

    Subscription.create(:device_id => self.device_id, :brand_id => brand.id, :brand_title => brand.title)
  end

  def unsubscribe!(brand)
    if !brand.respond_to?(:id)
      brand_str = brand
      brand = Brand.find_by_title(brand)
      return unless brand
    end
    
    subscription = subscriptions.find_by_brand_id(brand.id)
    subscription.destroy if subscription    
  end
end
