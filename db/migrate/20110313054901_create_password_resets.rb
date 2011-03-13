class CreatePasswordResets < ActiveRecord::Migration
  def self.up
    create_table :password_resets do |t|
      t.string :forgot_code
      t.integer :merchant_id
      t.string :ip_address

      t.timestamps
    end
     execute "ALTER TABLE `password_resets` ADD `used` ENUM('true', 'false')"
  end

  def self.down
    drop_table :password_resets
  end
end
