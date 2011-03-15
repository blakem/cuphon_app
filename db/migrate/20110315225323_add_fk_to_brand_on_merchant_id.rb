class AddFkToBrandOnMerchantId < ActiveRecord::Migration
  def self.up
    execute "alter table brands add constraint FK_brands_merchant_id_merchant_id foreign key (merchant_id) references merchants(id) on delete cascade"
  end

  def self.down
    execute "alter table brands drop index FK_brands_merchant_id_merchant_id"
  end
end
