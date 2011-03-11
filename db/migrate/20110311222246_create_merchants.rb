class CreateMerchants < ActiveRecord::Migration
  def self.up
    create_table :merchants do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :phone
      t.string :company_name
      t.string :keyword
      t.string :ip_address
      t.string :setup_key
      t.string :cc_number
      t.string :cc_month
      t.string :cc_year
      t.string :cc_code
      t.integer :cc_updated

      t.timestamps
    end
  end

  def self.down
    drop_table :merchants
  end
end
