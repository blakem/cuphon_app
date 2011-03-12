class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :foreign_key => 'device_id', :primary_key => 'device_id'

  def brands
    # has_many :brands, :through => :subscriptions
    self.subscriptions.map{ |s| s.brand }
  end
end
