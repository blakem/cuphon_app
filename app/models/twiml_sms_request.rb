# == Schema Information
# Schema version: 20110311201654
#
# Table name: twiml_sms_requests
#
#  id          :integer         not null, primary key
#  SmsSid      :string(255)
#  AccountSid  :string(255)
#  From        :string(255)
#  To          :string(255)
#  Body        :string(255)
#  FromCity    :string(255)
#  FromState   :string(255)
#  FromZip     :string(255)
#  FromCountry :string(255)
#  ToCity      :string(255)
#  ToState     :string(255)
#  ToZip       :string(255)
#  ToCountry   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  response    :string(255)
#

class TwimlSmsRequest < ActiveRecord::Base
  
  def self.create_from_params(params)
    attribute_keys = self.new.attributes.keys
    self.create(params.reject{|k,v| !attribute_keys.member?(k.to_s) })
  end
end
