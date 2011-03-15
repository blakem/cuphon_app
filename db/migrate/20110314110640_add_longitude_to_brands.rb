class AddLongitudeToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :longitude, :string
    add_column :brands, :latitude, :string
    execute "ALTER TABLE `brands` ADD `checked` ENUM('true', 'false') default 'false'"
  end

  def self.down
    remove_column :brands, :longitude
    remove_column :brands, :latitude
    execute "ALTER TABLE `brands` DROP `checked`"
  end
end
