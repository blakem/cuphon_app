class CreateBrandInstants < ActiveRecord::Migration
  def self.up
    create_table :brands_instant do |t|
      t.integer :brand_id
      t.string :description
      t.text :extended
      t.string :image_url
      t.datetime :expires_at

      t.timestamps
    end
  end

  def self.down
    drop_table :brands_instant
  end
end
