class AddFkToBrandInstantsOnBrandId < ActiveRecord::Migration
  def self.up
    execute "alter table brands_instant add constraint FK_brands_instant_brand_id_brand_id foreign key (brand_id) references brands(id) on delete cascade"
  end

  def self.down
    execute "alter table brands_instant drop index FK_brands_instant_brand_id_brand_id"
  end
end
