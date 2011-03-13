class CreateShortUrlsLogs < ActiveRecord::Migration
  def self.up
    create_table :short_urls_log do |t|
      t.string :url
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :short_urls_log
  end
end
