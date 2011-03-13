# == Schema Information
# Schema version: 20110313064440
#
# Table name: preview_emails
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  ip_address :string(255)
#  created    :string(255)
#  referrer   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PreviewEmail < ActiveRecord::Base
end
