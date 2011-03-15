class CreateShortUrls < ActiveRecord::Migration
  def self.up
    create_table :short_urls do |t|
      t.string :url
      t.string :brand_title
      t.string :description
      t.string :extended
      t.string :image_url

      t.timestamps
    end
    execute "ALTER TABLE `short_urls` ADD `opened` ENUM('true', 'false')"
  end
  
  def self.down
    drop_table :short_urls
  end
end
