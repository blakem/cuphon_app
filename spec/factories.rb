Factory.sequence :email do |n|
  "personf-#{n+1}@example.com"
end

Factory.sequence :phone do |n|
  "+1415#{sprintf( '%07i', n+1 )}"
end

Factory.sequence :brand_title do |n|
  "YummyYummyFancyGoodFood_#{n+1}"
end

Factory.sequence :string do |n|
  n.to_s * 10
end

Factory.define :merchant do |merchant|
  merchant.name                  "My name is Merchant"
  merchant.email                 Factory.next(:email)
  merchant.password              "foobar"
  merchant.phone                 Factory.next(:phone)
  merchant.company_name          "FancyGlasses"
  merchant.keyword               "FancyGlasses"
  merchant.ip_address            "10.10.10.10"
  merchant.setup_key             "ASFAWEFADSF"
  merchant.cc_number             "???"
  merchant.cc_month              "???"
  merchant.cc_year               "???"
  merchant.cc_code               "???"
  merchant.cc_updated            "???"
end

Factory.define :brand do |brand|
  brand.title  Factory.next(:brand_title)
end

Factory.define :subscriber do |s|
  s.device_id  Factory.next(:phone)
end

