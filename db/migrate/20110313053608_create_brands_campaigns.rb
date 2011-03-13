class CreateBrandsCampaigns < ActiveRecord::Migration
  def self.up
    create_table :brands_campaigns do |t|
      t.integer :brand_id
      t.string :title
      t.string :description
      t.text :extended
      t.string :image_id
      t.datetime :expires_at
      t.integer :total_sent

      t.timestamps
    end
  end

  def self.down
    drop_table :brands_campaigns
  end
end
