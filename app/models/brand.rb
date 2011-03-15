# == Schema Information
# Schema version: 20110314110640
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
#  longitude   :string(255)
#  latitude    :string(255)
#  in_app      :string(0)       default("false")
#

class Brand < ActiveRecord::Base
  require 'short_url_generator'
  require 'outbound_messages'
  
  belongs_to :merchant
  after_initialize :init
  
  def init
    self.instant  ||= 'false' 
    self.active   ||= 'false'
    self.featured ||= 'false'
    self.in_app   ||= 'false'
  end
  
  def brands_instants
    # has_many :brands_instants
    BrandsInstant.where(:brand_id => self.id)
  end
  
  def send_active_message
    instant = self.brands_instants.first # xxx sort by updated_at time
    (short_url, base) = ShortUrlGenerator.short_url_and_base
    ShortUrl.create(:url => base, 
                    :brand_title => self.title, 
                    :description => instant.description,
                    :extended => instant.extended,
                    :image_url => instant.image_url)
    OutboundMessages.instant_cuphon_message(self.title, instant.description, short_url)
  end
  
  def has_active_instant?
    return false unless instant?
    self.brands_instants.any?
  end

  class << self
    def get_by_obj_or_string(brand)
      if !brand.respond_to?(:id)
        brand_str = brand
        brand = Brand.find_by_title(brand)
      end
      brand
    end
    
    def get_or_create(title)
      brand = self.find_by_title(title)
      return brand if brand
      brand = Brand.create(:title => Brand.canonicalize_title(title))
      BrandsInstant.create(:brand_id => brand.id)
      BrandAlias.create(:alias => BrandAlias.canonicalize_alias(title), :brand_id => brand.id)
      brand
    end
  
    def find_by_fuzzy_match(string)
      brand = find_by_title(string)
      unless brand
        brand_alias = BrandAlias.find_by_alias(string) || BrandAlias.find_by_alias(BrandAlias.canonicalize_alias(string))
        brand = brand_alias.brand if brand_alias
      end
      return brand
    end
  
    def canonicalize_title(title)
      return '' unless title 
      title.split.map { |w| a = w.split(//); a[0] = a[0].upcase; a.join('') }.join(' ')
    end
    
  end
end
