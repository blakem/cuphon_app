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
end
