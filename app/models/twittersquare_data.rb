# == Schema Information
# Schema version: 20110313064440
#
# Table name: twittersquare_data
#
#  id                  :integer(4)      not null, primary key
#  city                :string(255)
#  foursquare_venue_id :string(255)
#  venue_name          :string(255)
#  tweet_text          :string(255)
#  tweet_id            :string(255)
#  state               :string(255)
#  twitter_name        :string(255)
#  followers_count     :integer(4)
#  created             :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class TwittersquareData < ActiveRecord::Base
end
