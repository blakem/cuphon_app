# == Schema Information
# Schema version: 20110320012629
#
# Table name: bad_words
#
#  id         :integer(4)      not null, primary key
#  word       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class BadWord < ActiveRecord::Base
end
