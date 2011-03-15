# == Schema Information
# Schema version: 20110313064440
#
# Table name: subscriptions
#
#  id          :integer(4)      not null, primary key
#  brand_title :string(255)
#  brand_id    :integer(4)
#  device_id   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Subscription < ActiveRecord::Base
  has_one :brand, :foreign_key => 'id', :primary_key => 'brand_id'
  has_one :subscriber, :foreign_key => 'device_id', :primary_key => 'device_id'
end
