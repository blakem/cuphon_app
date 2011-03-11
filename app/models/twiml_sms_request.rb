class TwimlSmsRequest < ActiveRecord::Base
  
  def self.create_from_params(params)
    attribute_keys = self.new.attributes.keys
    self.create(params.reject{|k,v| !attribute_keys.member?(k.to_s) })
  end
end
