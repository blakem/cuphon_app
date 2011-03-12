class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :device_id
      t.string :push_id

      t.timestamps
    end
    execute "ALTER TABLE `subscribers` ADD `type` ENUM('sms', 'android', 'iphone')"
    execute "ALTER TABLE `subscribers` ADD `active` ENUM('true', 'false')"
  end

  def self.down
    drop_table :subscribers
  end
end
