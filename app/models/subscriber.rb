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
  def self.inheritance_column() 'my_type' end
  has_many :subscriptions, :foreign_key => 'device_id', :primary_key => 'device_id', :dependent => :destroy
  has_many :queued_messages, :foreign_key => 'device_id', :primary_key => 'device_id'
  
  after_initialize :init
  
  def init
    self.active ||= 'true'
    self.type ||=  'sms'
  end  
  
  def brands
    # has_many :brands, :through => :subscriptions
    self.subscriptions.map{ |s| s.brand }.select { |b| b }
  end

  def subscribe!(*brands)
    self.active = 'true'
    self.save
    brands.each do |brand|
      subscribe_to_brand!(brand)
    end
  end

  def unsubscribe!(*brands)
    brands.each do |brand|
      unsubscribe_to_brand!(brand)
    end
  end
  
  def unsubscribe_all!
    self.active = 'false'
    self.save
  end
      
  def is_subscribed?(brand)
    return false unless self.active?
    brand = Brand.get_by_obj_or_string(brand)
    return unless brand
    self.brands.include?(brand)
  end
  
  def active?
    self.active == "true"  
  end
  
  private

    def subscribe_to_brand!(brand)
      return unless brand
      if brand.class == String # XXX find better way to do this....
        brand_str = brand
        brand = Brand.get_or_create(brand)
      end
      Subscription.create(:device_id => self.device_id, :brand_id => brand.id, :brand_title => brand.title)
    end

    def unsubscribe_to_brand!(brand)
      brand = Brand.get_by_obj_or_string(brand)
      return unless brand
      subscription = subscriptions.find_by_brand_id(brand.id)
      subscription.destroy if subscription    
    end
  
end
