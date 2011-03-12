class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string :title
      t.belongs_to :merchant

      t.timestamps
    end
    execute "ALTER TABLE `brands` ADD `featured` ENUM('true', 'false')"
    execute "ALTER TABLE `brands` ADD `instant` ENUM('true', 'false')"
    execute "ALTER TABLE `brands` ADD `active` ENUM('true', 'false')"
  end

  def self.down
    drop_table :brands
  end
end
