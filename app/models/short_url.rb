# == Schema Information
# Schema version: 20110314110640
#
# Table name: short_urls
#
#  id          :integer(4)      not null, primary key
#  url         :string(255)
#  brand_title :string(255)
#  description :string(255)
#  extended    :string(255)
#  image_url   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  opened      :string(0)
#

class ShortUrl < ActiveRecord::Base
  after_initialize :init
  
  def init
    self.opened  ||= 'false' 
  end
  
  def opened?
    self.opened == 'true'
  end
end
