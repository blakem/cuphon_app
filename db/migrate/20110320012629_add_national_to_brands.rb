class AddNationalToBrands < ActiveRecord::Migration
  def self.up
     execute "ALTER TABLE `brands` ADD `national` ENUM('true', 'false') NOT NULL"
  end

  def self.down
    remove_column :brands, :national
  end
end
