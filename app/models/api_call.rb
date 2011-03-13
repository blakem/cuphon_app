# == Schema Information
# Schema version: 20110313064440
#
# Table name: api_calls
#
#  id         :integer(4)      not null, primary key
#  device_id  :string(255)
#  call       :string(255)
#  response   :text
#  payload    :text
#  variables  :text
#  created_at :datetime
#  updated_at :datetime
#

class ApiCall < ActiveRecord::Base
end
