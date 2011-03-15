class AddFkToSubscriptionsOnDeviceId < ActiveRecord::Migration
  def self.up
    execute "alter table subscriptions add constraint FK_subscriptions_device_id_subscribers_device_id foreign key (device_id) references subscribers(device_id) on delete cascade"
  end

  def self.down
    execute "alter table subscriptions drop index FK_subscriptions_device_id_subscribers_device_id"
  end
end
