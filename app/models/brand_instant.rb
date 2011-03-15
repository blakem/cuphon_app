# == Schema Information
# Schema version: 20110314110640
#
# Table name: brands_instant
#
#  id          :integer(4)      not null, primary key
#  brand_id    :integer(4)
#  description :string(255)
#  extended    :text
#  image_url   :string(255)
#  expires_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class BrandInstant < ActiveRecord::Base  
  def self.table_name() "brands_instant" end
  belongs_to :brand
end
