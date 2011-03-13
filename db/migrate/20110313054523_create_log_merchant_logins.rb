class CreateLogMerchantLogins < ActiveRecord::Migration
  def self.up
    create_table :log_merchant_logins do |t|
      t.integer :merchant_id
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :log_merchant_logins
  end
end
