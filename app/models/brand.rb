# == Schema Information
# Schema version: 20110312023249
#
# Table name: brands
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  merchant_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  featured    :string(0)
#  instant     :string(0)
#  active      :string(0)
#

class Brand < ActiveRecord::Base
  require 'short_url_generator'
  require 'outbound_messages'
  
  belongs_to :merchant
  after_initialize :init
  
  def init
    self.instant  ||= false 
    self.active ||= false
    self.featured ||=  false
  end
  
  def self.get_by_obj_or_string(brand)
    if !brand.respond_to?(:id)
      brand_str = brand
      brand = Brand.find_by_title(brand)
    end
    brand
  end
    
  def brands_instants
    # has_many :brands_instants
    BrandsInstant.where(:brand_id => self.id)
  end
  
  def send_active_message
    instant = self.brands_instants.first # xxx sort by updated_at time
    short_url = ShortUrlGenerator.short_url
    ShortUrl.create(:url => short_url)
    OutboundMessages.instant_cuphon_message(self.title, instant.description, short_url)
  end
  
  def has_active_instant?
    return false unless instant?
    self.brands_instants.any?
  end
  
  def self.get_or_create(title)
    brand = self.find_by_title(title)
    return brand if brand
    brand = Brand.create(:title => title)
    BrandsInstant.create(:brand_id => brand.id)
    brand
  end
  
  def self.find_by_fuzzy_match(string)
    brand = find_by_title(string)
    if brand.nil?
      brand_alias = BrandsAlias.find_by_alias(string)
      if !brand_alias.nil?
        brand = brand_alias.brand
      end
    end
    return brand
  end
end
