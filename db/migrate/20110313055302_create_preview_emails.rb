class CreatePreviewEmails < ActiveRecord::Migration
  def self.up
    create_table :preview_emails do |t|
      t.string :email
      t.string :ip_address
      t.string :created
      t.string :referrer

      t.timestamps
    end
  end

  def self.down
    drop_table :preview_emails
  end
end
