# == Schema Information
# Schema version: 20110313064440
#
# Table name: log_instant_cuphons
#
#  id         :integer(4)      not null, primary key
#  device_id  :string(255)
#  brand_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class LogInstantCuphon < ActiveRecord::Base
end
