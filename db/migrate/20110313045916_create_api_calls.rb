class CreateApiCalls < ActiveRecord::Migration
  def self.up
    create_table :api_calls do |t|
      t.string :device_id
      t.string :call
      t.text :response
      t.text :payload
      t.text :variables

      t.timestamps
    end
  end

  def self.down
    drop_table :api_calls
  end
end
