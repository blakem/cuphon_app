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
  belongs_to :merchant
  has_many :brands_instants
  
  def self.get_by_obj_or_string(brand)
    if !brand.respond_to?(:id)
      brand_str = brand
      brand = Brand.find_by_title(brand)
    end
    brand
  end
    
  # def send_active_message
  #   self.brands_instants.first
  # end
  # 
  # def has_active_instant?
  #   self.brands_instants
  # end
end
