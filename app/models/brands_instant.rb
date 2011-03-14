# == Schema Information
# Schema version: 20110313064440
#
# Table name: brands_instant
#
#  id          :integer(4)      not null, primary key
#  brand_id    :integer(4)
#  title       :string(255)
#  description :string(255)
#  extended    :text
#  image_id    :string(255)
#  expires_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class BrandsInstant < ActiveRecord::Base
  require 'outbound_messages'

  def self.table_name() "brands_instant" end

  belongs_to :brand

  def generate_sms_text
    OutboundMessages.instant_cuphon_message(self.brand.title, self.description, "http://SOMEURL")
  end
end
