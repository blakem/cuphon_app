# == Schema Information
# Schema version: 20110313064440
#
# Table name: log_merchant_logins
#
#  id          :integer(4)      not null, primary key
#  merchant_id :integer(4)
#  ip_address  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class LogMerchantLogin < ActiveRecord::Base
end
