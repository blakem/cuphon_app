# == Schema Information
# Schema version: 20110313064440
#
# Table name: short_urls
#
#  id                :integer(4)      not null, primary key
#  url               :string(255)
#  merchant_title    :string(255)
#  unsubscribe_title :string(255)
#  text_1            :string(255)
#  text_2            :string(255)
#  image_url         :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  opened            :string(0)
#

class ShortUrl < ActiveRecord::Base
  after_initialize :init
  
  def init
    self.opened  ||= 'false' 
  end
end
