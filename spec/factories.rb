Factory.define :merchant do |merchant|
  merchant.name                  "My name is Merchant"
  merchant.email                 "testuser@blakem.com"
  merchant.password              "foobar"
  merchant.phone                 "415-112-2222"
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

Factory.sequence :email do |n|
  "personf-#{n+1}@example.com"
end

Factory.sequence :phone do |n|
  "+1415#{sprintf( '%07i', n+1 )}"
end