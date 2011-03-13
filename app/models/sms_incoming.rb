# == Schema Information
# Schema version: 20110313064440
#
# Table name: sms_incoming
#
#  id         :integer(4)      not null, primary key
#  sid        :string(255)
#  from       :string(255)
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SmsIncoming < ActiveRecord::Base
  def self.table_name() "sms_incoming" end
end
