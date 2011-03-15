class AddFkToBrandAliasOnBrandId < ActiveRecord::Migration
  def self.up
    execute "alter table brands_aliases add constraint FK_brands_aliases_brand_id_brand_id foreign key (brand_id) references brands(id) on delete cascade"
  end

  def self.down
    execute "alter table brands_aliases drop index FK_brands_aliases_brand_id_brand_id"
  end
end
