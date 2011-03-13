# == Schema Information
# Schema version: 20110313064440
#
# Table name: brands_campaigns
#
#  id          :integer(4)      not null, primary key
#  brand_id    :integer(4)
#  title       :string(255)
#  description :string(255)
#  extended    :text
#  image_id    :string(255)
#  expires_at  :datetime
#  total_sent  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class BrandsCampaign < ActiveRecord::Base
end
