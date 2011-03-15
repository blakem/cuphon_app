class CreateBrandAliases < ActiveRecord::Migration
  def self.up
    create_table :brands_aliases do |t|
      t.integer :brand_id
      t.string :alias

      t.timestamps
    end
  end

  def self.down
    drop_table :brands_aliases
  end
end
