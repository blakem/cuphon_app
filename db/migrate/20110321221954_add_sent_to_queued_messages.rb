class AddSentToQueuedMessages < ActiveRecord::Migration
  def self.up
    add_column :queued_messages, :sent, :int
    add_column :queued_messages, :sent_at, :datetime
  end

  def self.down
    remove_column :queued_messages, :sent_at
    remove_column :queued_messages, :sent
  end
end
