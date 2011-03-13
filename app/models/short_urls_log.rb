# == Schema Information
# Schema version: 20110313064440
#
# Table name: short_urls_log
#
#  id         :integer(4)      not null, primary key
#  url        :string(255)
#  ip_address :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ShortUrlsLog < ActiveRecord::Base
  def self.table_name() "short_urls_log" end
end
