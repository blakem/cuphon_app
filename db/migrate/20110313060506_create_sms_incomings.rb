class CreateSmsIncomings < ActiveRecord::Migration
  def self.up
    create_table :sms_incoming do |t|
      t.string :sid
      t.string :from
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :sms_incoming
  end
end
