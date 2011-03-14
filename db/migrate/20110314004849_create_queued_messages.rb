class CreateQueuedMessages < ActiveRecord::Migration
  def self.up
    create_table :queued_messages do |t|
      t.string :device_id
      t.string :body
      t.integer :priority

      t.timestamps
    end
  end

  def self.down
    drop_table :queued_messages
  end
end
