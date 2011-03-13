class CreateApiCuphons < ActiveRecord::Migration
  def self.up
    create_table :api_cuphons do |t|
      t.string :device_id
      t.integer :brand_id
      t.integer :campaign_id
      t.string :title
      t.string :description
      t.string :extended
      t.string :image_id
      t.string :short_url
      t.datetime :expires_at
      t.datetime :deleted_at
      t.datetime :opened_at

      t.timestamps
    end
  end

  def self.down
    drop_table :api_cuphons
  end
end
