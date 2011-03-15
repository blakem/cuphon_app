# == Schema Information
# Schema version: 20110313064440
#
# Table name: brands_aliases
#
#  id         :integer(4)      not null, primary key
#  brand_id   :integer(4)
#  alias      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class BrandsAlias < ActiveRecord::Base
  belongs_to :brand

  def self.canonicalize_alias(string)
    return '' unless string
    string.downcase.gsub(/\s+/, '').gsub(/[^[a-z0-9]]+/, '')
  end
end
