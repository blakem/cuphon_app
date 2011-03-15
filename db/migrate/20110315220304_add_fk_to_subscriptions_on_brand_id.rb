class AddFkToSubscriptionsOnBrandId < ActiveRecord::Migration
  def self.up
    execute "alter table subscriptions add constraint FK_subscriptions_brand_id_brand_id foreign key (brand_id) references brands(id) on delete cascade"
  end

  def self.down
    execute "alter table subscriptions drop index FK_subscriptions_brand_id_brand_id"
  end
end
