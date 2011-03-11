class TwimlSmsRequest < ActiveRecord::Base
  
  def self.new_from_params(params)
    sms_args = params
    sms_args.delete('format')
    sms_args.delete('controller')
    sms_args.delete('action')
    self.new(sms_args)
  end
end
