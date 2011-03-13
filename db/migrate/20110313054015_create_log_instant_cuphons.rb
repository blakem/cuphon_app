class CreateLogInstantCuphons < ActiveRecord::Migration
  def self.up
    create_table :log_instant_cuphons do |t|
      t.string :device_id
      t.integer :brand_id

      t.timestamps
    end
  end

  def self.down
    drop_table :log_instant_cuphons
  end
end
