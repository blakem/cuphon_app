# == Schema Information
# Schema version: 20110313064440
#
# Table name: api_discover
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  brand_id   :integer(4)
#  expires_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  featured   :string(0)
#  instant    :string(0)
#

class ApiDiscover < ActiveRecord::Base
  def self.table_name() "api_discover" end
  after_initialize :init

  def init
    self.instant  ||= 'false' 
    self.featured ||=  'false'
  end
  
  def featured?
    self.featured == 'true'
  end

  def instant?
    self.instant == 'true'
  end
end
