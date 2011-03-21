# == Schema Information
# Schema version: 20110321221954
#
# Table name: queued_messages
#
#  id         :integer(4)      not null, primary key
#  device_id  :string(255)
#  body       :string(255)
#  priority   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  sent       :integer(4)
#  sent_at    :datetime
#

class QueuedMessage < ActiveRecord::Base
  belongs_to :subscriber, :foreign_key => :device_id, :primary_key => :device_id
end
