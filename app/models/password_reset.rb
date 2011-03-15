# == Schema Information
# Schema version: 20110313064440
#
# Table name: password_resets
#
#  id          :integer(4)      not null, primary key
#  forgot_code :string(255)
#  merchant_id :integer(4)
#  ip_address  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  used        :string(0)
#

class PasswordReset < ActiveRecord::Base
  after_initialize :init
  
  def init
    self.used ||= 'false' 
  end
end
