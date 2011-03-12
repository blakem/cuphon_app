class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :brand_title
      t.integer :brand_id
      t.string :device_id

      t.timestamps
    end
    add_index :subscriptions, :brand_id
    add_index :subscriptions, :device_id
  end

  def self.down
    drop_table :subscriptions
  end
end
