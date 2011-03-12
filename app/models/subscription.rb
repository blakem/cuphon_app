class Subscription < ActiveRecord::Base
  has_one :brand, :foreign_key => 'id', :primary_key => 'brand_id'
end
