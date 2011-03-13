class CreateApiDiscovers < ActiveRecord::Migration
  def self.up
    create_table :api_discover do |t|
      t.string :title
      t.integer :brand_id
      t.datetime :expires_at

      t.timestamps
    end
    execute "ALTER TABLE `api_discover` ADD `featured` ENUM('true', 'false')"
    execute "ALTER TABLE `api_discover` ADD `instant` ENUM('true', 'false')"
  end

  def self.down
    drop_table :api_discover
  end
end
