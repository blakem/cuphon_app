class AddConstraintToSubscriberDeviceId < ActiveRecord::Migration
  def self.up
    execute "alter table subscribers add index subscribers_device_id_idx (device_id)"
  end

  def self.down
    execute "alter table subscribers drop index subscribers_device_id_idx"
  end
end
