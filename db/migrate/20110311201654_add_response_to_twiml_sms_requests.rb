class AddResponseToTwimlSmsRequests < ActiveRecord::Migration
  def self.up
    add_column :twiml_sms_requests, :response, :string
  end

  def self.down
    remove_column :twiml_sms_requests, :response
  end
end
