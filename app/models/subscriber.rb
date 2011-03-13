# == Schema Information
# Schema version: 20110313064440
#
# Table name: subscribers
#
#  id         :integer(4)      not null, primary key
#  device_id  :string(255)
#  push_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  type       :string(0)
#  active     :string(0)
#

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
    brand = Brand.get_by_obj_or_string(brand)
    return unless brand
    subscription = subscriptions.find_by_brand_id(brand.id)
    subscription.destroy if subscription    
  end
  
  def unsubscribe_all!
    self.brands.each do |brand|
      self.unsubscribe!(brand)
    end
  end
      
  def is_subscribed?(brand)
    brand = Brand.get_by_obj_or_string(brand)
    return unless brand
    self.brands.include?(brand)
  end
end
