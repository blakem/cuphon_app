# == Schema Information
# Schema version: 20110313064440
#
# Table name: api_cuphons
#
#  id          :integer(4)      not null, primary key
#  device_id   :string(255)
#  brand_id    :integer(4)
#  campaign_id :integer(4)
#  title       :string(255)
#  description :string(255)
#  extended    :string(255)
#  image_id    :string(255)
#  short_url   :string(255)
#  expires_at  :datetime
#  deleted_at  :datetime
#  opened_at   :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class ApiCuphon < ActiveRecord::Base
end
