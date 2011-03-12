# == Schema Information
# Schema version: 20110312023249
#
# Table name: merchants
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  email        :string(255)
#  password     :string(255)
#  phone        :string(255)
#  company_name :string(255)
#  keyword      :string(255)
#  ip_address   :string(255)
#  setup_key    :string(255)
#  cc_number    :string(255)
#  cc_month     :string(255)
#  cc_year      :string(255)
#  cc_code      :string(255)
#  cc_updated   :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Merchant < ActiveRecord::Base
end
