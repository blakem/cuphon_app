class CreateTwittersquareData < ActiveRecord::Migration
  def self.up
    create_table :twittersquare_data do |t|
      t.string :city
      t.string :foursquare_venue_id
      t.string :venue_name
      t.string :tweet_text
      t.string :tweet_id
      t.string :state
      t.string :twitter_name
      t.integer :followers_count
      t.string :created

      t.timestamps
    end
  end

  def self.down
    drop_table :twittersquare_data
  end
end
