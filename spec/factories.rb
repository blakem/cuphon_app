Factory.sequence :email do |n|
  "personf-#{n+1}@example.com"
end

Factory.sequence :phone do |n|
  "+1415#{sprintf( '%07i', n+1 )}"
end

Factory.define :merchant do |merchant|
  merchant.name                  "My name is Merchant"
  merchant.sequence(:email)      { Factory.next(:email) }
  merchant.password              "foobar"
  merchant.sequence(:phone)      { Factory.next(:phone) }
  merchant.company_name          "FancyGlasses"
  merchant.keyword               "FancyGlasses"
  merchant.ip_address            "10.10.10.10"
  merchant.setup_key             "ASFAWEFADSF"
end

Factory.define :brand do |brand|
  brand.sequence(:title) { |n| "YummyGoodFood_#{n+1}" }
  brand.instant                  'true'
end

Factory.define :subscriber do |s|
  s.sequence(:device_id) { Factory.next(:phone) }
end

Factory.define :brand_instant do |instant|
  instant.association :brand, :factory => :brand
end

Factory.define :brand_alias do |brand_alias|
  brand_alias.association :brand, :factory => :brand
end

Factory.define :user do |user|
  user.sequence(:email)  { Factory.next(:email) }
  user.password          "foobar"
  user.invite_code       User.secret_invite_code
end