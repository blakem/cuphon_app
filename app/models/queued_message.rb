# == Schema Information
# Schema version: 20110314004849
#
# Table name: queued_messages
#
#  id         :integer(4)      not null, primary key
#  device_id  :string(255)
#  body       :string(255)
#  priority   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class QueuedMessage < ActiveRecord::Base
end
